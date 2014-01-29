class Videatra < Sinatra::Application
	get "/" do
		erb :index
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
