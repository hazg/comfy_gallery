require 'comfy_gallery'
require 'rails'
require 'paperclip'

module ComfyGallery
  class Engine < Rails::Engine
    initializer 'comfy_gallery.helper' do |app|
      if defined?(ComfortableMexicanSofa)
        # applying configuraion
        ComfyGallery.configure do |conf|
          conf.admin_route_prefix = 'cmsadmin'#ComfortableMexicanSofa.config.admin_route_prefix
          conf.upload_options     = ComfortableMexicanSofa.config.upload_file_options
          conf.admin_controller   = 'Comfy::Admin::Cms::BaseController'
          conf.form_builder       = 'ComfortableMexicanSofa::FormBuilder'
        end
        # applying nav elements
        ComfortableMexicanSofa::ViewHooks.add(:navigation, '/admin/gallery/navigation')
      end
    end

    # Sort the layouts by display name
    config.after_initialize do
      ComfyGallery.config.layouts.sort! { |a,b| a.name <=> b.name }
    end
  end
end
