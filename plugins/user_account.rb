PlugMan.define :user_account do
  author 'Dobromir Ivanov'
  version '0.0.1'
  extends ({})
  requires [:main]
  extension_points []
  params()

  Videatra.get '/user/account/?' do
    if !current_user
      flash[:error] = "You need to login first!"
      redirect '/log_in'
    end

    erb MAIN.render_path('account').to_sym
  end

  Videatra.post '/user/account/update' do
    if !current_user
      flash[:error] = "You need to login first!"
      redirect '/log_in'
    end

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
    if !current_user
      flash[:error] = "You need to login first!"
      redirect '/log_in'
    end

    current_user.profile.destroy if current_user.profile
    current_user.subscription_plans.destroy if current_user.subscription_plans
    currnet_user.destroy
    logout
    redirect '/'
  end

  def start
    CreateProfiles.new.up
    true
  end
end
