class SubscriptionPlan < ActiveRecord::Base
  has_and_belongs_to_many :videos

  has_many :subscription_plans_users
  has_many :users, :through => :subscription_plans_users
end
