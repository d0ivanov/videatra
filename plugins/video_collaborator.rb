PlugMan.define :video_collaborator do
  author 'Dobromir Ivanov'
  version '0.0.1'
  extends ({guardian: [:filter_conditions, :event_filter_failed], main: [:event_after_video_save, :event_after_video_update]})
  requires [:main, :rolify, :subscribeme]
  extension_points []
  params()

  filter_by_role = Proc.new do |user|
    (user && !(user.user_roles & ["admin", "colaborator"]).empty?)
  end

  subscriber_role = Proc.new do |user|
    (user && !(user.user_roles & ["admin", "subscriber", "colaborator"]).empty?)
  end

  @protected_routes = {
    "/videos/upload/?"   => filter_by_role,
    "/videos/edit/:id/?" => filter_by_role,
    "/videos/delete/:id" => filter_by_role,
    "/videos/watch/:id/?" => subscriber_role,
  }

  def set_video_plans video, request
    plans = []
    request.POST["video"]["subscription_plans"].each do |plan_id|
      plans.push SubscriptionPlan.find_by_id plan_id
    end
    video.subscription_plans = plans
    video.save
  end

  def filter_conditions current_user, path, params
    return true if (filter = @protected_routes[path]).nil?
    return filter.call(current_user)
  end

  def event_filter_failed path, response
    response.redirect "/log_in"
  end

  def event_after_video_save video, request, response
    set_video_plans vide, request
  end

  def event_after_video_update video, request, response
    set_video_plans vide, request
  end
end
