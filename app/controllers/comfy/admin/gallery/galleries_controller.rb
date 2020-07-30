class Comfy::Admin::Gallery::GalleriesController < Comfy::Admin::Gallery::BaseController

  before_filter :load_gallery,  :except => [:index, :new, :create]
  before_filter :build_gallery, :only   => [:create]
  before_filter :setup_layouts, :except => [:index]

  def index
    if params[:category].present?
      @galleries = Gallery::Gallery.for_category(params[:category]).all
    else
      @galleries = Gallery::Gallery.all
    end
  end

  def new
    @gallery = Gallery::Gallery.new
    render
  end

  def create
    @gallery.save!
    flash[:notice] = 'Gallery created'
    redirect_to comfy_admin_gallery_photos_path(@site, @gallery) and return
  rescue ActiveRecord::RecordInvalid
    flash.now[:error] = 'Failed to create Gallery'
    render :action => :new
  end

  def show
    render
  end

  def edit
    render
  end

  def update
    @gallery.update_attributes!(gallery_params[:gallery])
    flash[:notice] = 'Gallery updated'
    redirect_to :action => :index
  rescue ActiveRecord::RecordInvalid
    flash.now[:error] = 'Failed to update Gallery'
    render :action => :edit
  end

  def destroy
    @gallery.destroy
    flash[:notice] = 'Gallery deleted'
    redirect_to :action => :index
  end

protected

  def load_gallery
    @gallery = Gallery::Gallery.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Gallery not found'
    redirect_to :action => :index
  end

  def build_gallery
    @gallery = Gallery::Gallery.new(gallery_params[:gallery])
  end

  def gallery_params
    params.require(:gallery).permit(:title,:identifier,:description,:full_width,:full_height,:force_ratio_full,:thumb_width,:thumb_height,:force_ratio_thumb)
    params.permit!
  end

  # Build an array of available layouts that will display the gallery
  def setup_layouts
    @layouts = []
    ComfyGallery.config.layouts.each do |layout|
      @layouts << [layout.name, layout.id]
    end
    @layouts
  end

end
