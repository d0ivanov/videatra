extension_points = [
  :event_after_file_upload,
  :event_after_file_upload_failure,

  :event_after_video_save,
  :event_after_video_save_failure,

  :event_after_video_update,
  :event_after_video_update_failure,

  :event_before_video_delete,
  :event_after_video_delete
]

MAIN.extension_points + extension_points

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
end
