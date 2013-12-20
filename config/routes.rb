require 'sinatra/redirect_with_flash'
class Videatra < Sinatra::Application
	get "/" do
		erb :index
	end

	get "/admin" do
		env['warden'].authenticate!
		if env['warden'].authenticated?
			"awesome"
		else
			"bad"
		end
	end
end
