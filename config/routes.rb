class Videatra < Sinatra::Application
	get "/" do
		erb :index
	end

	get "/admin" do
		if authenticated?
			"awesome"
		else
			"bad"
		end
	end

  get "/cool" do
    flash[:notice]
  end

end
