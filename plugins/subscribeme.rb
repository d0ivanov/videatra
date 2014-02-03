require_relative "subscribeme/migrate/create_subscriptions_table"
require_relative "subscribeme/models/user"
require_relative "subscribeme/models/video"
require_relative "subscribeme/models/subscription_plan"
require_relative "subscribeme/models/subscription_plans_users"

PlugMan.define :subscribeme do
  author 'Dobromir Ivanov'
  version '0.0.1'
  extends ({guardian: [:filter_conditions, :event_filter_failed]})
  requires [:main, :rolify]
  extension_points []
  params()

  filter_by_subscription = Proc.new { |user, params|
    video = Video.find_by_id(params[:id])
    (user && user.subscribed?(video))
  }

  @protected_routes = {
    "/videos/watch/:id/?" => filter_by_subscription
  }

  def start
    CreateSubscriptionPlan.new.up
    true
  end

  def filter_conditions current_user, path, params
    return true if (filter = @protected_routes[path]).nil?
    return filter.call(current_user, params)
  end

  def event_filter_failed path, response
    response.redirect "/subscribe"
  end
end
