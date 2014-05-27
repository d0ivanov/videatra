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
  }

  def filter_conditions current_user, path, params
    return true if (filter = @protected_routes[path]).nil?
    return filter.call(current_user)
  end

  def event_filter_failed path, response
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
