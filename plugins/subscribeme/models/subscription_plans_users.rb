class SubscriptionPlansUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :subscription_plan

  def expired?
    Time.now > created_at + subscription_plan.duration * 24 * 3600
  end
end
