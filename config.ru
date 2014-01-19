require './app'

class Videatra
  set :root, Proc.new {File.dirname(__FILE__)}
  settings.dirspec[:models] = File.join(root, settings.dirspec[:models])
  settings.dirspec[:views] = File.join(root, settings.dirspec[:views])
  settings.dirspec[:helpers] = File.join(root, settings.dirspec[:helpers])

  set :erb, :format => :html5
  set :partial_template_engine, :erb

  I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
  I18n.load_path = Dir[File.join(settings.root, 'locales', '*.yml')]
  I18n.backend.load_translations
  I18n.enforce_available_locales = true
  I18n.default_locale = settings.locales[:default_locale]
end

run Videatra
