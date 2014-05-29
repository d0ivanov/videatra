PlugMan.define :administrator do
  author 'Dobromir Ivanov'
  version '0.0.1'
  extends ({guardian: [:filter_conditions, :event_filter_failed], main: [:filter_user_dropdown_menu]})
  requires [:main, :rolify]
  extension_points []
  params()

  filter_by_role = Proc.new do |user|
    (user && !(user.user_roles & ["admin", "colaborator"]).empty?)
  end

  @protected_routes = {
    "/administrator/?"   => filter_by_role,
    "/administrator/subscriptions/?"   => filter_by_role,
    "/administrator/subscriptions/edit/:id/?"   => filter_by_role,
    "/administrator/subscriptions/delete/:id"   => filter_by_role,
  }

  def filter_conditions current_user, path, params
    return true if (filter = @protected_routes[path]).nil?
    return filter.call(current_user)
  end

  def event_filter_failed path, response
    throw :halt, 401
    response.redirect "/log_in"
  end

  def filter_user_dropdown_menu user
    if @protected_routes["/administrator/?"].call user
      return "<li><a href=\"/administrator\" tabindex=\"-1\"><i class=\"icon-white icon-edit\"></i>Administration</a></li>"
    end
  end

  Videatra.get '/administrator/?' do
    @video_links = Video.all
    erb MAIN.render_path('administrator_layout').to_sym
  end

  Videatra.get '/administrator/subscriptions/new' do
    erb MAIN.render_path('new_plan').to_sym
  end

  Videatra.post '/administrator/subscriptions/create' do
    @plan = SubscriptionPlan.new(params[:plan])
    if @plan.save
      flash[:notice] = "Plan created!"
    else
      flash[:error] = "Could not create plan!"
    end
    redirect "/administrator/subscriptions"
  end

  Videatra.get '/administrator/subscriptions/edit/:id/?' do
    @plan = SubscriptionPlan.find_by_id params[:id]
    erb MAIN.render_path('edit_plan').to_sym
  end

  Videatra.post '/administrator/subscriptions/edit/:id' do
    @plan = SubscriptionPlan.find_by_id params[:id]
    if @plan
      @plan.update_attributes params[:plan]
      flash[:notice] = "Plan updated!"
    else
      flash[:error] = "Plan not found!"
    end
    redirect "/administrator/subscriptions"
  end

  Videatra.post '/administrator/subscriptions/delete/:id' do
    @plan = SubscriptionPlan.find_by_id params[:id]
    if @plan
      @plan.destroy
      flash[:notice] = "Plan deleted!"
    else
      flash[:error] = "Plan not found!"
    end
    redirect "/administrator/subscriptions"
  end

  Videatra.get '/administrator/subscriptions/?' do
    @plans = SubscriptionPlan.all
    if !@plans.nil?
      erb MAIN.render_path('subscriptions').to_sym
    else
      flash[:notice] = "No plans!"
      redirect "/administrator"
    end
  end

  edit_video_route = Videatra.get "/videos/edit/:id/?" do
    @video = Video.find_by_id(params[:id])
    @subscription_plans = SubscriptionPlan.all
    if @video
      erb MAIN.render_path('edit_video').to_sym
    else
      flash[:error] = "Video not found!"
      redirect "/administrator"
    end
  end

  upload_video_route = Videatra.get "/videos/upload/?" do
    @subscription_plans = SubscriptionPlan.all
    erb MAIN.render_path('upload_video').to_sym
  end

  edit_video_route.promote
  upload_video_route.promote
end
