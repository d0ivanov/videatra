require 'active_record'
require 'protected_attributes'
require 'yaml'

class Videatra < Sinatra::Base
  db = YAML.load(ERB.new(File.read(File.join("#{settings.root}", "/config/database.yml"))).result)
  ActiveRecord::Base.establish_connection(db[settings.environment.to_s])
end
