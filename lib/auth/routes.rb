require_relative 'helpers'

module Routes
	def self.new app
		@app = app
	end

	#Renders the registration form
	@app.get '/signup/?' do
		redirect '/' if authenticated?
		erb 'views/signup'.to_sym
	end

	#renders the login form
	@app.get '/login/?' do
		redirect '/' if authenticated?
		erb 'views/login'.to_sym
	end

	@app.post '/create_user/?' do
		redurect '/' if authenticated?

		user = User.new(params)
		if user.valid?
			user.save!
			redirect '/', :notice => "User created successfully!"
		else
			redirect '/signup', :error => user.errors.messages
		end
	end

	#Creates the session
	@app.post '/create_session' do
		authenticate!
		redirect '/', :notice => "Successfully logged in!" if authenticated?
	end

	@app.get '/logout/?' do
		logout
		redirect '/'
	end

end
