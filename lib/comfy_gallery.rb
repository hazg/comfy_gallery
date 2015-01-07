# Loading engine only if this is not a standalone installation
unless defined? ComfyGallery::Application
  require File.expand_path('comfy_gallery/engine', File.dirname(__FILE__))
end

require File.expand_path('comfy_gallery/configuration', File.dirname(__FILE__))
require File.expand_path('comfy_gallery/form_builder', File.dirname(__FILE__))
require File.expand_path('comfy_gallery/routing', File.dirname(__FILE__))
require File.expand_path('paperclip_processors/cropper', File.dirname(__FILE__))

module ComfyGallery
  class << self
    
    def configure
      yield configuration
    end
    
    def configuration
      @configuration ||= Configuration.new
    end
    alias :config :configuration
    
  end
end
