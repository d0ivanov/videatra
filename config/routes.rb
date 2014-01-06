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

  post "/cool" do
    puts params
  end

end
