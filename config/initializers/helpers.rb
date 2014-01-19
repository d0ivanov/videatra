class Videatra < Sinatra::Application
	Dir["#{settings.dirspec[:helpers]}/*.rb"].each {|file| require file}
end
