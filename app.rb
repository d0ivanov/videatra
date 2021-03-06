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
require_relative 'config/initializers/plugman'
require_relative 'config/routes'

class Videatra < Sinatra::Base

  Videatra.each_route do |route|
    before route.path do
      authenticate! :remember_me if cookies["authstrategies"]
      guardian = PlugMan.registered_plugins[:guardian]
      guardian.filter_before_route(current_user, route.path, params, response)
    end
  end

  before '/_reload_plugins' do
    if !current_user.has_role? "admin"
      halt 401, "You need administrator privileges!"
      redirect "/"
    end
  end

  after do
    #So that we don't get too many connections
    #up at the same time
    ActiveRecord::Base.connection.close
  end
end

def reload_plugins
  PlugMan.stop_all_plugins
  PlugMan.registered_plugins.delete_if { |k, v| k != :root and k != :main }
  PlugMan.load_plugins './plugins'
  PlugMan.start_all_plugins
  auth_hooks
  video_hooks
end

# A new thread that is looping and on every 10 secs change if
# the list of .rb files inside plugins/ is changed. If changed
# we call reload_plugins
Thread.new do
  files = Dir.glob "plugins/user_plugins/*.rb"
  loop do
    new_files = Dir.glob "plugins/user_plugins/*.rb"
    if new_files != files
      reload_plugins
      files = new_files
    end
    sleep(10)
  end
end
