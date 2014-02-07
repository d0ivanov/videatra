require_relative 'user_profile/models/user'
require_relative 'user_profile/migrate/create_profiles'

include Views
PlugMan.define :user_profile do
  author 'Dobromir Ivanov'
  version '0.0.1'
  extends ({guardian: [:filter_conditions, :event_filter_failed]})
  requires [:main]
  extension_points []
  params()

  filter = Proc.new do |use|
    return !!user
  end

  @protected_routes = {
    "/user/profile/?"        => filter,
    "/user/profile/create/?" => filter,
    "/user/profile/create"   => filter,
    "/user/profile/update"   => filter,
  }

  Videatra.get '/user/profile/?' do
    redirect '/user/profile/create' if !current_user.profile
    erb MAIN.render_path('profile').to_sym
  end

  Videatra.get '/user/profile/create/?' do
    redirect '/user/profile' if current_user.profile
    erb MAIN.render_path('create_profile').to_sym
  end

  Videatra.post '/user/profile/create' do
    profile = Profile.new(params)
    profile.user = current_user
    if profile.valid?
      profile.save
      redirect '/user/profile'
    else
      flash[:message] = "Invalid data!"
      redirect back
    end
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

  def start
    CreateProfiles.new.up
    true
  end

  def filter_conditions current_user, path, params
    return true if (filter = @protected_routes[path]).nil?
    return filter.call(current_user)
  end

  def event_filter_failed path, response
    response.redirect "/log_in"
  end
end
