require_relative "subscribeme/migrate/create_subscriptions_table"
require_relative "subscribeme/models/user"
require_relative "subscribeme/models/video"
require_relative "subscribeme/models/subscription_plan"
require_relative "subscribeme/models/subscription_plans_users"

PlugMan.define :subscribeme do
  author 'Dobromir Ivanov'
  version '0.0.1'
  extends ({guardian: [:filter_conditions, :event_filter_failed], main: [:filter_user_dropdown_menu]})
  requires [:main, :rolify]
  extension_points []
  params()

  filter_by_subscription = Proc.new do |user, params|
    video = Video.find_by(id: params[:id])
    if !video
      false
    else
      (user && user.subscribed?(video))
    end
  end

  filter_by_user = Proc.new do |user, params|
    !user.nil?
  end

  @protected_routes = {
    "/videos/watch/:id/?" => filter_by_subscription,
    "/subscribe/?" => filter_by_user,
    "/user/subscriptions/?" => filter_by_user,
    "/user/subscriptions/delete/:id" => filter_by_user,
  }

  def start
    CreateSubscriptionPlan.new.up
    true
  end

  def filter_conditions current_user, path, params
    return true if (filter = @protected_routes[path]).nil?
    filter.call(current_user, params)
  end

  def event_filter_failed path, response
    throw :halt, 401
    response.redirect "/subscribe"
  end

  def filter_user_dropdown_menu user
    "<li><a href=\"/user/subscriptions\" tabindex=\"-1\"><i class=\"icon-white icon-edit\"></i>Subscriptions</a></li>"
  end

  Videatra.get "/subscribe/?" do
    flash[:error] = "Plugin not activated!"
    redirect back
  end

  Videatra.get "/user/subscriptions/?" do
    @plans = current_user.subscription_plans
    erb MAIN.render_path("subscriptions").to_sym
  end

  Videatra.post "/user/subscriptions/delete/:id" do
    plan = current_user.subscription_plans.each do |plan|
      plan if plan.id == params[:id]
    end
    plan.destroy!
  end
end
