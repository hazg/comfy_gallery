module ComfyGallery
  class Configuration
    
    # Paperclip upload settings for photos
    attr_accessor :upload_options
  
    # Controller that should be used for admin area
    attr_accessor :admin_controller
    
    # Form builder
    attr_accessor :form_builder
    
    # Array of available gallery layout partials. Each entry must be a hash with a display_name, and file_name.
    attr_accessor :layouts
    # Name of layout to use by default
    attr_accessor :default_layout

    # Number of seconds to allow an expiring URL to an S3 asset be valid. Default 10 seconds
    attr_accessor :s3_timeout

    # Configuration defaults
    def initialize
      @upload_options     = { }
      @admin_controller   = 'ApplicationController'
      @form_builder       = 'ComfyGallery::FormBuilder'
      @s3_timeout         = 10
      @layouts            = [
        Gallery::Layout.new("three", "three_in_a_row")
      ]
      @default_layout     = @layouts.first
    end
    
  end
end
