require 'authstrategies'
require 'authstrategies/helpers'

class Videatra < Sinatra::Base
  Authstrategies::Manager.config do |config|
    config[:default_locales] = settings.locales[:default_locale]

    config[:after_login_path] = settings.pathspec[:authentication][:after_login]
    config[:after_logout_path] = settings.pathspec[:authentication][:after_logout]
    config[:after_signup_path] = settings.pathspec[:authentication][:after_signup]
  end

  use Authstrategies::Middleware
	helpers Authstrategies::Helpers
end
