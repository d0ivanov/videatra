PlugMan.define :main do
  author 'Mihail Zdravkov & Dobromir Ivanov'
  version  '0.0.1'
  extends({root: [:root]})
  requires []
  extension_points [
    :filter_before_route,
    :filter_layout_meta,
    :filter_layout_page_title,
    :filter_layout_includes,
    :filter_layout_head,
    :filter_layout_body,
    #Auth hooks

    :event_before_login_failure,
    :event_before_logout,

    :event_after_set_user,
    :event_after_authentication,
    :event_after_login_failure,
    :event_after_logout,
    :event_after_login,
    :event_after_signup,

    #Video extension points
    :event_after_file_upload,
    :event_after_file_upload_failure,

    :event_after_video_save,
    :event_after_video_save_failure,

    :event_after_video_update,
    :event_after_video_update_failure,

    :event_before_video_delete,
    :event_after_video_delete
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

auth_hooks
video_hooks
