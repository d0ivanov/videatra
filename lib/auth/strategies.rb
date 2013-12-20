require 'warden'
require 'sinatra/base'
require_relative 'base'
require_relative 'remember_me'

module AuthStrategies

	class Warden::SessionSerializer
		def serialize user
			user.id
		end

		def deserialize id
			User.find(id)
		end
	end

	#
	#Password strategy
	#
	class PasswordStrategy < Warden::Strategies::Base
		def valid?
			!!(params["email"] && params["password"])
		end

		def authenticate!
			user = User.find_by_email(params["email"])
			puts user.authenticate(request)
			if user && user.authenticate(request)
				success!(user)
			else
				fail!()
			end
		end
	end

	#
	#Remember me strategy
	#
	COOKIE_KEY = "videatra.remember"
	class RememberMeStrategy < Warden::Strategies::Base
		def valid?
			!!env['rack.request.cookie_hash'][COOKIE_KEY]
		end

		def authenticate!
			token = env['rack.request.cookie_hash'][COOKIE_KEY]
			puts token
			return unless token
			user = User.first(:remember_token => token)
			env['rack.cookies'].delete(COOKIE_KEY) and return if user.nil?
			success!(user)
		end
	end

	class Middleware < Sinatra::Base
		register Base
		register RememberMe
	end
end
