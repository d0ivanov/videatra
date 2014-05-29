PlugMan.define :user_account do
  author 'Dobromir Ivanov'
  version '0.0.1'
  extends ({main: [:filter_user_dropdown_menu], guardian: [:filter_conditions, :event_filter_failed]})
  requires [:main]
  extension_points []
  params()

  filter_by_user = Proc.new do |user|
    !user.nil?
  end

  @protected_routes = {
    '/user/account/?' => filter_by_user,
    '/user/account/update' => filter_by_user,
    '/user/account/delete' => filter_by_user,
  }

  def start
    CreateProfiles.new.up
    true
  end

  def filter_conditions current_user, path, params
    return true if (filter = @protected_routes[path]).nil?
    return filter.call(current_user)
  end

  def event_filter_failerd path, response
    throw :halt, 401
    response.redirect "/sign_in"
  end

  def filter_user_dropdown_menu current_user
    "<li><a href=\"/user/account\" tabindex=\"-1\"><i class=\"icon-white icon-edit\"></i>Edit accound</a></li>"
  end

  Videatra.get '/user/account/?' do
    erb MAIN.render_path('account').to_sym
  end

  Videatra.post '/user/account/update' do
    redirect '/user/account' if current_user.password != params["current_password"]
    if current_user.update_attributes(params)
      current_user.save
      flash[:notice] = "Successfully updated account!"
    else
      flash[:error] = "Could not update account!"
    end
    redirect '/user/account'
  end

  Videatra.get '/user/account/delete' do
    current_user.profile.destroy if current_user.profile
    current_user.subscription_plans.destroy if current_user.subscription_plans
    currnet_user.destroy
    logout
    redirect '/'
  end
end
