require 'sinatra'
require 'sinatra/partial'
require 'sinatra/config_file'
require 'sinatra/cookies'
require 'sinatra/videoman'
require 'authstrategies'
require 'authstrategies/helpers'
require 'rack/flash'
require 'rack/contrib'
require 'i18n'
require 'i18n/backend/fallbacks'

class Videatra < Sinatra::Application
  register Sinatra::ConfigFile
  register Sinatra::Partial
  register Sinatra::Videoman::Middleware

  config_file './config/application.yml'

  use Rack::Session::Cookie, {
    :secret => settings.cookies[:secret],
    :expire_after => settings.cookies[:expire_time]
  }
  use Rack::Flash
  use Rack::Locale
  use Authstrategies::Middleware

	helpers Rack::Utils
	helpers	Sinatra::Cookies
	helpers Authstrategies::Helpers

  before do
    PlugMan.extensions(:main, :filter_before).each do |plugin|
      plugin.before request, current_user
    end
  end

  after do
    PlugMan.extensions(:main, :filter_after).each do |plugin|
      plugin.after request, current_user
    end
  end
end

require_relative 'config/initializers/authstrategies'
require_relative 'config/initializers/videoman'
require_relative 'config/initializers/models'
require_relative 'config/initializers/helpers'
require_relative 'lib/PlugMan'
require_relative 'plugman/main'
require_relative 'config/routes'
