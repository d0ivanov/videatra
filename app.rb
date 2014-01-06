require 'sinatra'
require 'sinatra/config_file'
require 'sinatra/cookies'
require 'sinatra/videoman'
require 'authstrategies'
require 'authstrategies/helpers'
require 'rack/flash'

class Videatra < Sinatra::Application
  register Sinatra::ConfigFile
  config_file './config/application.yml'

  set :root, Proc.new {File.dirname(__FILE__)}
  set :models_dir, Proc.new {File.join(root, settings.models_folder)}
  set :views_dir, Proc.new {File.join(root, settings.views_folder)}
  set :erb, :format => :html5
  set :helpers_dir, Proc.new {File.join(root, settings.helpers_folder)}

  use Rack::Session::Cookie, {
    :secret => settings.cookie_secret,
    :expire_after => settings.cookie_expire_time.to_i
  }
  use Rack::Flash
  use Authstrategies::Middleware
  use Sinatra::Videoman::Middleware

	helpers Rack::Utils
	helpers	Sinatra::Cookies
	helpers Authstrategies::Helpers

  Sinatra::Videoman::Manager.config do |config|
    config[:video_upload_dir] = settings.root + '/public/uploads'
    config[:thumb_upload_dir] = settings.root + '/public/uploads/thumbnails'
  end
end

require_relative 'config/initializers/models'
require_relative 'config/initializers/helpers'
require_relative 'config/routes'
