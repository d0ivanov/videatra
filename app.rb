require 'sinatra'
require 'sinatra/flash'
require 'sinatra/partial'
require 'sinatra/config_file'
require 'sinatra/cookies'
require 'sinatra/advanced_routes'
require 'sinatra/paginate'
require 'sinatra/support'
require 'rack/contrib'
require 'i18n'
require 'i18n/backend/fallbacks'

class Videatra < Sinatra::Base
  register Sinatra::AdvancedRoutes
  register Sinatra::ConfigFile
  register Sinatra::Partial
  register Sinatra::Flash
  register Sinatra::Paginate

  config_file './config/application.yml'

  use Rack::Session::Cookie, {
    :secret => settings.cookies[:secret],
    :expire_after => settings.cookies[:expire_time]
  }
  use Rack::Locale

	helpers Rack::Utils
	helpers	Sinatra::Cookies
  helpers Sinatra::CountryHelpers

  enable :sessions

end

require_relative 'config/initializers/database'
require_relative 'config/initializers/helpers'
require_relative 'config/initializers/videoman'
require_relative 'config/initializers/authstrategies'
require_relative 'config/routes'
require_relative 'lib/PlugMan'
require_relative 'plugman/main'

class Videatra < Sinatra::Base

  Videatra.each_route do |route|
    before route.path do
      authenticate! :remember_me if cookies["authstrategies"]
      guardian = PlugMan.registered_plugins[:guardian]
      guardian.filter_before_route(current_user, request.path_info, params, response)
    end
  end

  after do
    #So that we don't get too many connections
    #up at the same time
    ActiveRecord::Base.connection.close
  end
end
