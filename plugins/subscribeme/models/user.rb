class User < ActiveRecord::Base
  has_and_belongs_to_many :subscription_plans

  def subscribed? video
    !(subscription_plans & video.subscription_plans).empty?
  end
end
