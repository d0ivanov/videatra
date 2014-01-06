extension_points = [
  :filter_video_upload_dir,
  :filter_video_file_extensions,
  :filter_max_video_file_size,

  :filter_thumb_upload_dir,
  :filter_thumb_file_extensions,
  :filter_max_thumb_file_size,

  :filter_after_video_save_path,
  :filter_after_video_save_msg,

  :filter_after_video_update_path,
  :filter_after_video_update_msg,
  :filter_after_video_update_failure_path,

  :filter_after_video_delete_path,
  :filter_after_video_delete_msg,

  :event_after_file_upload,
  :event_after_file_upload_failure,

  :event_after_video_save,
  :event_after_video_save_failure,

  :event_after_video_update,
  :event_after_video_update_failure,

  :event_before_video_delete,
  :event_after_video_delete
]

resources = {
  :video_upload_dir => nil,
  :video_file_extensions => %w(ogv webm mp4),
  :max_video_file_size => 400,

  :thumb_upload_dir => nil,
  :thumb_file_extensions => %w(jpg jpeg bmp),
  :max_thumb_file_size => 2,

  :after_video_save_path => '/',
  :after_video_save_msg => 'Successfully uploaded video!',

  :after_video_update_path => '/',
  :after_video_update_msg => 'Successfully updated video!',
  :after_video_update_failure_path => '/',

  :after_video_delete_path => '/',
  :after_video_delete_msg => 'Successfully deleted video!',
}

MAIN.extension_points += extension_points
MAIN.resources += resources

def video_hooks
  #events
  Sinatra::Videoman::Manager.after_file_upload do |file|
    MAIN.call :event_after_file_upload, file
  end

  Sinatra::Videoman::Manager.after_file_upload_failure do |request, response|
    MAIN.call :event_after_file_upload_failure, request, response
  end

  Sinatra::Videoman::Manager.after_video_save do |video, request, response|
    MAIN.call :event_after_video_save, video, request, response
  end

  Sinatra::Videoman::Manager.after_video_save_failure do |request, response|
    MAIN.call :event_after_video_save_failure, request, response
  end

  Sinatra::Videoman::Manager.after_video_update do |video, request, response|
    MAIN.call :event_after_video_update, video, request, response
  end

  Sinatra::Videoman::Manager.after_video_update_failure do |video, request, response|
    MAIN.call :event_after_video_update_failure, request, response
  end

  Sinatra::Videoman::Manager.before_video_delete  do |video, request, response|
    MAIN.call :event_before_video_delete, video, request, response
  end

  Sinatra::Videoman::Manager.after_video_delete do |request, response|
    MAIN.call :event_after_video_delete, request, response
  end

  Sinatra::Videoman::Manager.config[:video_upload_dir] = *MAIN.get(:filter_video_upload_dir)
  Sinatra::Videoman::Manager.config[:video_file_extensions] = *MAIN.get(:filter_video_file_extensions)
  Sinatra::Videoman::Manager.config[:max_video_file_size] = *MAIN.get(:filter_max_video_file_size)
  Sinatra::Videoman::Manager.config[:thumb_upload_dir] = *MAIN.get(:filter_thumb_upload_dir)
  Sinatra::Videoman::Manager.config[:thumb_file_extensions] = *MAIN.get(:filter_thumb_file_extensions)
  Sinatra::Videoman::Manager.config[:max_thumb_file_size] = *MAIN.get(:filter_max_thumb_file_size)
  Sinatra::Videoman::Manager.config[:after_video_save_path] = *MAIN.get(:filter_after_video_save_path)
  Sinatra::Videoman::Manager.config[:after_video_save_msg] = *MAIN.get(:filter_after_video_save_msg)
  Sinatra::Videoman::Manager.config[:after_video_update_path] = *MAIN.get(:filter_after_video_update_path)
  Sinatra::Videoman::Manager.config[:after_video_update_msg] = *MAIN.get(:filter_after_video_update_msg)
  Sinatra::Videoman::Manager.config[:after_video_update_failure_path] = *MAIN.get(:filter_after_video_update_failure_path)
  Sinatra::Videoman::Manager.config[:after_video_delete_path] = *MAIN.get(:filter_after_video_delete_path)
  Sinatra::Videoman::Manager.config[:after_video_delete_msg] = *MAIN.get(:filter_after_video_delete_msg)
end
