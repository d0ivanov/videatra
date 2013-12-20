class Videatra < Sinatra::Application
	Dir["#{settings.helpers_dir}/*.rb"].each {|file| require file}
	helpers Views
end
