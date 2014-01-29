PlugMan.define :main do
  author 'mzdravkov and d0ivanov'
  version  '0.0.1'
  extends({root: [:root]})
  requires []
  #should be symbols
  extension_points [:filter_before_route, :filter_video_title]
  params()

  def call event, *args
    PlugMan.extensions(:main, "#{event}").each do |plugin|
      plugin.send("#{event}", *args)
    end
  end
end

MAIN = PlugMan.registered_plugins[:main]

require './plugman/authentication'
require './plugman/videos'

auth_hooks
video_hooks

PlugMan.load_plugins './plugins'
PlugMan.start_all_plugins
