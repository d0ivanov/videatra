require 'active_record'
require 'protected_attributes'

class Videatra < Sinatra::Application
  ActiveRecord::Base.establish_connection(settings.database)
end
