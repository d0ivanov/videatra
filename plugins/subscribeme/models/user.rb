class User < ActiveRecord::Base
  has_many :subscription_plans_users
  has_many :subscription_plans, :through => :subscription_plans_users

  def subscribed? video
    plans = subscription_plans & video.subscription_plans
    delete_expired_plans plans
    !(subscription_plans & video.subscription_plans).empty?
  end

  private
    def delete_expired_plans plans
      plans.each do |plan|
         plan.subscription_plans_users.each do |user_plan|
           user_plan.destroy if user_plan.expired?
        end
      end
    end
end
