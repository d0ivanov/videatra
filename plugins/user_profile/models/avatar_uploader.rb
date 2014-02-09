require 'digest/sha1'

class AvatarUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    'public/uploads/avatars'
  end

  def extension_white_list
    ["jpg", "png", "jpeg"]
  end

  def filename
    if original_filename
      @name ||= Digest::MD5.hexdigest(File.dirname(current_path))
      "#{@name}.#{file.extension}"
    end
  end

  def default_url
    '/uploads/avatars/default_profile_picture.png'
  end
end
