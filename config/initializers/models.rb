require 'active_record'
require 'protected_attributes'

class Videatra < Sinatra::Application

	ActiveRecord::Base.establish_connection(settings.database)
	Dir["#{settings.dirspec[:models]}/*.rb"].each {|file| require file}

end
