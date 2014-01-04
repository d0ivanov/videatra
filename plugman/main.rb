PlugMan.define :main do
  author 'mzdravkov and d0ivanov'
  version  '0.0.1'
  extends({root: [:root]})
  requires []
  #should be symbols
  extension_points []
  params()

  # name: default_value pairs, where name is symbol
  @resources = {}

  attr_accessor :resources

  def get resource
    resource = resource.to_sym
    current = @resources[resource]
    PlugMan.extensions(:main, "filter_#{resource}").each do |plugin|
      current = plugins.send("filter_#{resource}", current)
    end
    current
  end

  def call event, *args
    PlugMan.extensions(:main, "event_#{event}").each do |plugin|
      plugin.send("event_#{event}", *args)
    end
  end
end

MAIN = PlugMan.registered_plugins[:main]

require './plugman/authentication'

get '/_reload_plugins' do
	PlugMan.stop_all_plugins
	PlugMan.registered_plugins.delete_if { |k, v| k != :root and k != :main }
	PlugMan.load_plugins './plugins'
	PlugMan.start_all_plugins
  auth_hooks
  redirect '/'
end

PlugMan.load_plugins './plugins'
PlugMan.start_all_plugins
auth_hooks
