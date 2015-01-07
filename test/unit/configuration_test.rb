require File.expand_path('../test_helper', File.dirname(__FILE__))

class ConfigurationTest < ActiveSupport::TestCase
  
  def test_configuration_presense
    assert config = ComfyGallery.configuration
    assert_equal ({}),                        config.upload_options
    assert_equal 'ApplicationController',     config.admin_controller
    assert_equal 'ComfyGallery::FormBuilder',  config.form_builder
  end
  
  def test_initialization_overrides
    ComfyGallery.configuration.admin_controller = 'ApplicationController'
    assert_equal 'ApplicationController', ComfyGallery.configuration.admin_controller
  end
  
end
