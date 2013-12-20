require_relative 'helpers'
require_relative 'strategies'

module Base

	AUTH_FAILURE_MSG = "Invalid username or password!"

	FailureApp = lambda { |env|
		env['x-rack.flash'][:error] = AUTH_FAILURE_MSG
		[302, {'Location' => '/login'}, ['']]
	}

	def self.registered(app)
		app.helpers Helpers

		app.use Warden::Manager do |manager|
			manager.failure_app = FailureApp
			manager.default_strategies :password
		end

		Warden::Strategies.add(:password, AuthStrategies::PasswordStrategy)

		#Renders the registration form
		app.get '/signup/?' do
			redirect '/' if authenticated?
			erb :signup
		end

		#renders the login form
		app.get '/login/?' do
			redirect '/' if authenticated?
			erb :login
		end

		app.post '/create_user/?' do
			redurect '/' if authenticated?

			user = User.new(params)
			if user.valid?
				user.save!
				flash[:notice] = "User created successfully!"
				redirect '/'
			else
				flash[:error] = user.errors.messages
				redirect '/signup'
			end
		end

		#Creates the session
		app.post '/create_session/?' do
			authenticate!
			flash[:notice] = "Success!"
			redirect '/'  if authenticated?
		end

		app.get '/logout/?' do
			logout
			redirect '/'
		end
	end
end
