require_relative 'user_profile/models/user'
require_relative 'user_profile/migrate/create_profiles'
include Views

PlugMan.define :user_profile do
  author 'Dobromir Ivanov'
  version '0.0.1'
  extends ({main: [:event_after_signup, :filter_user_dropdown_menu, :filter_header_menu_dropdown], guardian: [:filter_conditions, :event_filter_failed]})
  requires [:main]
  extension_points []
  params()

  filter_by_user = Proc.new do |user|
    !user.nil?
  end

  @protected_routes = {
    '/user/profile/?' => filter_by_user,
    '/user/profile/update' => filter_by_user,
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

  def event_after_signup user, request, response
    profile = Profile.new(first_name: 'First Name', last_name: 'Last Name', country: 'BG')
    user.profile = profile
    user.profile.save
    user.subscription_plans = [SubscriptionPlan.find_by_name('Free')]
    user.roles = [Role.find_by_role('subscriber')]
    user.save
  end

  def filter_user_dropdown_menu current_user
    "<li><a href=\"/user/profile\" tabindex=\"-1\"><i class=\"icon-white icon-edit\"></i>Edit profile</a></li>"
  end

  def filter_header_menu_dropdown current_user
    "<span class=\"avatar\"><img src=\"" + current_user.profile.avatar.url + "\" alt=\"avatar\" /></span>" + current_user.profile.first_name
  end

  Videatra.get '/user/profile/?' do
    erb MAIN.render_path('profile').to_sym
  end

  Videatra.post '/user/profile/update' do
    if current_user.profile.update_attributes(params)
      current_user.profile.save
      flash[:notice] = "Successfully updated profile!"
    else
      flash[:error] = "Could not update profile!"
    end
    redirect '/user/profile'
  end
end
