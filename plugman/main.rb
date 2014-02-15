PlugMan.define :main do
  author 'mzdravkov and d0ivanov'
  version  '0.0.1'
  extends({root: [:root]})
  requires []
  #should be symbols
  extension_points [:filter_before_route, :filter_title, :filter_header_logo,
                    :filter_header, :filter_loged_in_header_menu, :filter_not_loged_in_header_menu,
                    :filter_footer_menu, :filter_footer, :filter_footer_social, :filter_landing,
                    :filter_index_heading
                   ]
  params()

  def call event, *args
    PlugMan.extensions(:main, "#{event}").each do |plugin|
      plugin.send("#{event}", *args)
    end
  end

  #Assumes you views are located in a views subdirectory
  #of a directory with the same name as your plugin file.
  #e.g if you call this from a file named "vim", your
  #view should be located int vim/views
  def render_path erb
    File.join "../plugins", File.basename(caller[0][/[^:]+/],".rb"), "views", erb
  end
end

MAIN = PlugMan.registered_plugins[:main]

require './plugman/authentication'
require './plugman/videos'

auth_hooks
video_hooks

PlugMan.load_plugins './plugins'
PlugMan.start_all_plugins
