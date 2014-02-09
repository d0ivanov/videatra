class User < ActiveRecord::Base
  has_one :profile, dependent: :destroy
end
