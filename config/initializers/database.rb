require 'active_record'
require 'protected_attributes'

class Videatra < Sinatra::Base
  ActiveRecord::Base.establish_connection(settings.database)
end
