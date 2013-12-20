require 'active_record'
require 'sinatra/activerecord'

class Videatra < Sinatra::Application

	ActiveRecord::Base.establish_connection(settings.database)
	Dir["#{settings.models_dir}/*.rb"].each {|file| require file}

end
