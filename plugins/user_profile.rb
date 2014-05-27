require_relative 'user_profile/models/user'
require_relative 'user_profile/migrate/create_profiles'
include Views

PlugMan.define :user_profile do
  author 'Dobromir Ivanov'
  version '0.0.1'
  extends ({main: [:event_after_signup]})
  requires [:main]
  extension_points []
  params()

  Videatra.get '/user/profile/?' do
    if !current_user
      flash[:error] = "You need to login first!"
      redirect '/log_in'
    end

    erb MAIN.render_path('profile').to_sym
  end

  Videatra.post '/user/profile/update' do
    if !current_user
      flash[:error] = "You need to login first!"
      redirect '/log_in'
    end

    if current_user.profile.update_attributes(params)
      current_user.profile.save
      flash[:notice] = "Successfully updated profile!"
    else
      flash[:error] = "Could not update profile!"
    end
    redirect '/user/profile'
  end

  def start
    CreateProfiles.new.up
    true
  end

  def event_after_signup user, request, response
    profile = Profile.new(first_name: 'First Name', last_name: 'Last Name', country: 'BG')
    user.profile = profile
    user.profile.save
    user.subscription_plans = [SubscriptionPlan.find_by_id(1)]
    user.roles = [Role.find_by_role('subscriber')]
    user.save
  end
end
