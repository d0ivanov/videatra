class Videatra < Sinatra::Base
  Dir["#{settings.dirspec[:helpers]}/*.rb"].each {|file| require File.join(settings.root, file)}
  helpers Views
end
