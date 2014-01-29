require 'sinatra/videoman'

class Videatra
  Sinatra::Videoman::Manager.config do |config|
    config[:default_locales] = settings.locales[:default_locale]
#    config[:locales_dir] = settings.locales[:locales_dir]

    config[:video_upload_dir] = root + settings.upload_spec[:videos]['upload_dir']
    config[:video_file_extensions] = settings.upload_spec[:videos]['allowed_extensions']
    config[:max_video_file_size] = settings.upload_spec[:videos]['max_file_size']
    config[:thumb_upload_dir] = root + settings.upload_spec[:thumbnails]['upload_dir']
    config[:thumb_file_extensions] = settings.upload_spec[:thumbnails]['allowed_extensions']
    config[:max_thumb_file_size] = settings.upload_spec[:thumbnails]['max_file_size']

    config[:after_video_save_path] = settings.pathspec[:videos]['after_save']
    config[:after_video_update_path] = settings.pathspec[:videos]['after_update']
    config[:after_video_delete_path] = settings.pathspec[:videos]['after_delete']
  end

  register Sinatra::Videoman::Middleware
end
