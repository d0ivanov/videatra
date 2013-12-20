require 'sinatra'
require 'sinatra/config_file'
require 'sinatra/cookies'
require 'rack-flash'
require 'sinatra/redirect_with_flash'
require_relative 'lib/auth/strategies'

class Videatra < Sinatra::Application
	enable :sessions
	use Rack::Flash
	use AuthStrategies::Middleware

	register Sinatra::ConfigFile
	config_file './config/application.yml'

	set :root, Proc.new {File.dirname(__FILE__)}
	set :models_dir, Proc.new {File.join(root, settings.models_folder)}
	set :views_dir, Proc.new {File.join(root, settings.views_folder)}
	set :erb, :format => :html5
	set :helpers_dir, Proc.new {File.join(root, settings.helpers_folder)}


	helpers do
		include Rack::Utils
		Sinatra::RedirectWithFlash
		Sinatra::Cookies
	end

end

require_relative 'config/initializers/models'
require_relative 'config/initializers/helpers'
require_relative 'config/routes'
