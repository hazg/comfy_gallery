require File.expand_path('../../../test_helper', File.dirname(__FILE__))

class Admin::Gallery::PhotosControllerTest < ActionController::TestCase
  
  def test_get_index
    get :index, :gallery_id => gallery_galleries(:default)
    assert_response :success
    assert_template 'index'
    assert assigns(:photos)
  end
  
  def test_get_index_failure
    get :index, :gallery_id => 'invalid'
    assert_response :redirect
    assert_redirected_to comfy_admin_galleries_path
    assert_equal 'Gallery not found', flash[:error]
  end
  
  def test_new
    gallery = gallery_galleries(:default)
    get :new, :gallery_id => gallery
    assert_response :success
    assert_template 'new'
    assert assigns(:photo)
    assert_select "form[action='/admin/gallery/galleries/#{gallery.id}/photos']"
  end

  def test_create
    assert_difference 'Gallery::Photo.count' do
      post :create, :gallery_id => gallery_galleries(:default), :gallery_photo => {
        :title  => 'Test Photo',
        :image  => [fixture_file_upload('/files/default.jpg', 'image/jpeg')]
      }
      assert_response :redirect
      assert_redirected_to :action => :index
      assert_equal 'Photo created', flash[:notice]
      
      photo = Gallery::Photo.last
      assert_equal 'Test Photo', photo.title
    end
  end
  
  def test_create_without_title
    assert_difference 'Gallery::Photo.count', 2 do
      post :create, :gallery_id => gallery_galleries(:default), :gallery_photo => {
        :image  => [fixture_file_upload('/files/default.jpg', 'image/jpeg')]
      }
      assert_response :redirect
      assert_redirected_to :action => :index
      assert_equal 'Photo created', flash[:notice]
      
      photo = Gallery::Photo.last
      assert_equal 'default.jpg', photo.title
      
      post :create, :gallery_id => gallery_galleries(:default), :gallery_photo => {
        :image  => [fixture_file_upload('/files/default.jpg', 'image/jpeg')]
      }
      
      photo = Gallery::Photo.last
      assert_equal 'default.jpg', photo.title
    end
  end

  def test_create_failure
    assert_no_difference 'Gallery::Photo.count' do
      post :create, :gallery_id => gallery_galleries(:default), :gallery_photo => { }
      assert_response :success
      assert_template 'new'
      assert_equal 'Failed to create Photo', flash[:error]
    end
  end
  
  
  def test_create_multiple
    Gallery::Photo.delete_all
    
    assert_difference 'Gallery::Photo.count', 2 do
      post :create, :gallery_id => gallery_galleries(:default), :gallery_photo => {
        :title  => 'Test Photo',
        :image  => [
          fixture_file_upload('/files/default.jpg', 'image/jpeg'),
          fixture_file_upload('/files/default.jpg', 'image/jpeg')
        ]
      }
      assert_response :redirect
      assert_redirected_to :action => :index
      
      photo_a, photo_b = Gallery::Photo.all
      
      assert_equal 'default.jpg', photo_a.image_file_name
      assert_equal 'default.jpg', photo_b.image_file_name
      assert_equal 'Test Photo 1', photo_a.title
      assert_equal 'Test Photo 2', photo_b.title
      assert_equal 'Photo created', flash[:notice]
    end
  end
  
  
  def test_get_edit
    photo = gallery_photos(:default)
    get :edit, :gallery_id => photo.gallery, :id => photo
    assert_response :success
    assert_template 'edit'
    assert_select "form[action='/admin/gallery/galleries/#{photo.gallery.id}/photos/#{photo.id}']"
  end
  
  def test_get_edit_failure
    get :edit, :gallery_id => gallery_galleries(:default), :id => 'invalid'
    assert_response :redirect
    assert_redirected_to :action => :index
    assert_equal 'Photo not found', flash[:error]
  end
  
  def test_update
    photo = gallery_photos(:default)
    put :update, :gallery_id => photo.gallery, :id => photo, :gallery_photo => {
      :title => 'Updated Title'
    }
    assert_response :redirect
    assert_redirected_to :action => :index
    assert_equal 'Photo updated', flash[:notice]
    
    photo.reload
    assert_equal 'Updated Title', photo.title
  end
  
  def test_update_failure
    photo = gallery_photos(:default)
    put :update, :gallery_id => photo.gallery, :id => photo, :gallery_photo => {
      :title => 'Updated Title',
      :image => fixture_file_upload('/files/default.txt', 'text/plain')
    }
    assert_response :success
    assert_template :edit
    assert_equal 'Failed to updated Photo', flash[:error]
    
    photo.reload
    assert_not_equal 'Updated Title', photo.description
  end
  
  def test_destroy
    photo = gallery_photos(:default)
    assert_difference 'Gallery::Photo.count', -1 do
      delete :destroy, :gallery_id => photo.gallery, :id => photo
      assert_response :redirect
      assert_redirected_to :action => :index
      assert_equal 'Photo deleted', flash[:notice]
    end
  end
  
  def test_reorder    
    gallery = gallery_galleries(:default)
    photo_one = gallery_photos(:default)
    photo_two = Gallery::Photo.create!(
      :gallery  => gallery,
      :title    => 'Test Photo',
      :image    => fixture_file_upload('/files/default.jpg', 'image/jpeg')
    )
    assert_equal 0, photo_one.position
    assert_equal 1, photo_two.position

    post :reorder, :gallery_id => photo_one.gallery, :gallery_photo => [photo_two.id, photo_one.id]
    assert_response :success
    photo_one.reload
    photo_two.reload

    assert_equal 1, photo_one.position
    assert_equal 0, photo_two.position
  end
  
  # JW - crop is not working at the moment  
  
  # def test_get_crop
  #   photo = gallery_photos(:default)
  #   photo.image = fixture_file_upload('/files/default.jpg', 'image/jpeg')
  #   photo.save!
    
  #   get :crop, :gallery_id => photo.gallery, :id => photo
  #   assert_response :success
  #   assert_template 'crop'
  #   assert assigns(:photo)
  # end

  # def test_crop_thumbnail
  #   photo = gallery_photos(:default)
  #   put :update, :gallery_id => photo.gallery, :id => photo, :gallery_photo => {
  #       :photo => {
  #         :thumb_crop_x => '0', 
  #         :thumb_crop_y => '0', 
  #         :thumb_crop_w => '100', 
  #         :thumb_crop_h => '100'
  #       }
  #     }
    
  #   assert_response :redirect
  #   assert_redirected_to :action => :index
  #   assert_equal 'Photo updated', flash[:notice]
  # end
  
  
  # def test_crop_thumbnail_and_full
  #   gallery = Gallery::Gallery.create!(
  #     :title            => 'test',
  #     :identifier       => 'test',
  #     :force_ratio_full => true
  #   )
  #   photo = Gallery::Photo.create!(
  #     :gallery  => gallery,
  #     :title    => 'Test Photo',
  #     :image    => fixture_file_upload('/files/default.jpg', 'image/jpeg')
  #   )
  #   put :update, :gallery_photo => {
  #     :gallery_id => gallery, :id => photo, :photo => {
  #       :thumb_crop_x => '0', 
  #       :thumb_crop_y => '0', 
  #       :thumb_crop_w => '100', 
  #       :thumb_crop_h => '100',
  #       :full_crop_x => '0', 
  #       :full_crop_y => '0', 
  #       :full_crop_w => '100', 
  #       :full_crop_h => '100'
  #     }
  #   }
    
  #   assert_response :redirect
  #   assert_redirected_to :action => :index
  #   assert_equal 'Photo updated', flash[:notice]
  # end
  
end
