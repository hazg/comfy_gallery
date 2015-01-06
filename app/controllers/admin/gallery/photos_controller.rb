class Admin::Gallery::PhotosController < Admin::Gallery::BaseController
  
  before_filter :load_gallery
  before_filter :load_photo,  :only => [:edit, :update, :destroy, :crop]
  before_filter :build_photo, :only => [:new, :create]

  def index
    @photos = @gallery.photos
  end

  def new
    render
  end
  
  def create
    @photo = Gallery::Photo.new(params_for_create_and_update)
    @photo.save!
    
    flash[:notice] = 'Photo created'
    redirect_to :action => :index
  rescue ActiveRecord::RecordInvalid
    flash[:error] = 'Failed to create Photo'
    render :action => :new
  end
  
  def edit
    render
  end
  
  def update
    @photo.update_attributes!(params_for_create_and_update)
    flash[:notice] = 'Photo updated'
    redirect_to :action => :index
  rescue ActiveRecord::RecordInvalid
    flash.now[:error] = 'Failed to updated Photo'
    render :action => :edit
  end
  
  def destroy
    @photo.destroy
    flash[:notice] = 'Photo deleted'
    redirect_to :action => :index
  end
  
  def reorder
    (photo_params[:gallery_photo] || []).each_with_index do |id, index|
      if (photo = Gallery::Photo.find_by_id(id))
        photo.update_attribute(:position, index)
      end
    end
    render :nothing => true
  end
  
  def crop
    render
  end
  
protected
  
  def load_gallery
    @gallery = Gallery::Gallery.find(photo_params[:gallery_id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Gallery not found'
    redirect_to admin_gallery_galleries_path
  end
  
  def load_photo
    @photo = @gallery.photos.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Photo not found'
    redirect_to :action => :index
  end
  
  def build_photo
    @photo = Gallery::Photo.new({:gallery => @gallery}.merge(photo_params[:sofa_gallery_photo] || {}))
  end
  
  def photo_params
    params.permit!
  end

  #
  # This returns a hash that has been setup for creating or editing an image.
  # It ensures we have a photo title and that the image is available
  #
  def params_for_create_and_update
    full_params = photo_params
    adjusted_params = full_params[:gallery_photo]

    title = (adjusted_params[:title].blank? && full_params[:image] ? 
      full_params[:image].original_filename : 
      adjusted_params[:title]
    )
    adjusted_params = {:gallery => @gallery}.merge(adjusted_params.merge(:title => title) || {})
    if full_params[:image]
      adjusted_params = adjusted_params.merge(:image => full_params[:image]) 
    end
    adjusted_params
  end
end
