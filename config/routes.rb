class Videatra < Sinatra::Base
	get "/" do
    @video_links = Video.all
		erb :index
	end

  get '/log_in/?' do
    redirect '/' if authenticated?
    erb :'users/login'
  end

  get '/sign_up/?' do
    redirect '/' if authenticated?
    erb :'users/signup'
  end

  get '/_reload_plugins' do
    PlugMan.stop_all_plugins
    PlugMan.registered_plugins.delete_if { |k, v| k != :root and k != :main }
    PlugMan.load_plugins './plugins'
    PlugMan.start_all_plugins
    auth_hooks
    video_hooks
    redirect '/'
  end
end
