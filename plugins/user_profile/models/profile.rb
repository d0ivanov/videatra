require_relative 'avatar_uploader'

class Profile < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader
  belongs_to :user, dependent: :destroy

  validates :first_name, :last_name, :country, presence: true
  validate :file_size

  def file_size
    if avatar.file && (avatar.file.size.to_f / 2**20).round(2) > 2
      errors.add(:avatar, "You cannot upload a file greater than 2MB")
    end
  end

end
