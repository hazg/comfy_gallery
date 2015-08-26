class Comfy::Admin::Gallery::RevisionsController < Comfy::Admin::Cms::RevisionsController

protected
  
  def load_record
    @record = if params[:gallery_id]
      ::Gallery::Gallery.find(params[:gallery_id])
    end
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = I18n.t('comfy.admin.cms.revisions.record_not_found')
    redirect_to comfy_admin_cms_path(@site)
  end
  
  def redirect_to_record
    redirect_to case @record
      when ::Gallery::Gallery  then edit_comfy_admin_cms_site_gallery_path(@site, @record)
    end
  end

end
