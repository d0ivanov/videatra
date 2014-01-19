PlugMan.define :main do
  author 'mzdravkov and d0ivanov'
  version  '0.0.1'
  extends({root: [:root]})
  requires []
  #should be symbols
  extension_points [:plugin_routes, :filter_before_url, :filter_after_url]
  params()

  # name: default_value pairs, where name is symbol
  @resources = {}

  def resources
    @resources
  end

  def call event, *args
    PlugMan.extensions(:main, "event_#{event}").each do |plugin|
      plugin.send("event_#{event}", *args)
    end
  end

  def all_plugin_routes
    plugin_routes = []
    PlugMan.extensions(:main, :plugin_routes).each do |plugin|
      routes_with_plugin_name = plugin.plugin_routes.map { |a| [plugin.name] + a }
      plugin_routes << routes_with_plugin_name
    end
    plugin_routes.flatten(1)
  end

end

MAIN = PlugMan.registered_plugins[:main]

require './plugman/authentication'
require './plugman/videos'

get '/_reload_plugins' do
	PlugMan.stop_all_plugins
	PlugMan.registered_plugins.delete_if { |k, v| k != :root and k != :main }
	PlugMan.load_plugins './plugins'
	PlugMan.start_all_plugins
  auth_hooks
  video_hooks
  redirect '/'
end

PlugMan.load_plugins './plugins'
PlugMan.start_all_plugins
auth_hooks
video_hooks
