class Videatra
  Authstrategies::Manager.config do |config|
    config[:default_locales] = settings.locales[:default_locale]
    config[:locales_dir] = settings.locales[:locales_dir]

    config[:after_login_path] = settings.pathspec[:authentication][:after_login]
    config[:after_logout_path] = settings.pathspec[:authentication][:after_logout]
    config[:after_signup_path] = settings.pathspec[:authentication][:after_signup]
  end
end
