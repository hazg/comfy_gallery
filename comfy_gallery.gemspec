$LOAD_PATH.push File.expand_path("../lib", __FILE__)
require 'comfy_gallery/version'

Gem::Specification.new do |s|
  s.name = "comfy_gallery"
  s.version = ComfyGallery::VERSION

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Oleg Khabarov", "Stephen McLeod", "The Working Group Inc."]
  s.date = "2012-02-22"
  s.description = ""
  s.email = "oleg@twg.ca"
  s.extra_rdoc_files = [
    "LICENSE",
    "README.md"
  ]
  s.files      = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {spec,features}/*`.split("\n")
  s.homepage   = "http://github.com/comfy/comfy-gallery"
  s.licenses   = ["MIT"]
  s.require_paths = ["lib"]
  # s.rubygems_version = "1.8.10"
  s.summary = "ComfyGallery is an image gallery engine for Rails 4 apps (and ComfortableMexicanSofa)"

  s.add_dependency 'rails', '> 4.0.0'
  s.add_dependency "paperclip", ">= 2.3.0"
  s.add_dependency "jquery-rails"
  s.add_dependency "haml-rails"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "jeweler"
  s.add_development_dependency "pry"
  s.add_development_dependency "pry-nav"
end

