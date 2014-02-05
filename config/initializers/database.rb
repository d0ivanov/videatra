require 'active_record'
require 'protected_attributes'
require 'yaml'

class Videatra < Sinatra::Base
  db = YAML.load_file("#{settings.root}/config/database.yml")
  ActiveRecord::Base.establish_connection(db[settings.environment.to_s])
end
