# encoding: utf-8
$:.unshift(File.dirname(__FILE__))

require "config/environment"
require "app/app"

use Rack::CommonLogger


map "/" do
  run App
end

map "/assets" do
  Compass.configuration do |config|
    config.sass_dir = 'app/assets/css'
    config.images_path = 'app/assets/images'
  end

  sprockets_env = Sprockets::Environment.new('app/assets/')
  sprockets_env.append_path 'css'
  Dir.glob("css/**/*").each do |dir|
    sprockets_env.append_path dir if File.directory? dir
  end

  sprockets_env.append_path 'images'

  Sprockets::Helpers.configure do |config|
    config.environment = sprockets_env
    config.prefix      = "/assets"
    config.digest      = true
  end

  run sprockets_env
end