require 'sinatra'
require 'sinatra/partial'
require 'sinatra/config_file'
require 'sinatra/cookies'
require 'sinatra/advanced_routes'
require 'rack/flash'
require 'rack/contrib'
require 'i18n'
require 'i18n/backend/fallbacks'

class Videatra < Sinatra::Application
  register Sinatra::AdvancedRoutes
  register Sinatra::ConfigFile
  register Sinatra::Partial

  config_file './config/application.yml'

  use Rack::Session::Cookie, {
    :secret => settings.cookies[:secret],
    :expire_after => settings.cookies[:expire_time]
  }
  use Rack::Flash
  use Rack::Locale

	helpers Rack::Utils
	helpers	Sinatra::Cookies

end

require_relative 'config/initializers/database'
require_relative 'config/initializers/helpers'
require_relative 'config/initializers/authstrategies'
require_relative 'config/initializers/videoman'
require_relative 'config/routes'
require_relative 'lib/PlugMan'
require_relative 'plugman/main'

class Videatra < Sinatra::Application

  Videatra.each_route do |route|
    before route.path do
      PlugMan.extensions(:main, :filter_before_route).each do |plugin|
        plugin.filter_before_route(current_user, route.path, params, response)
      end
    end
  end
end
