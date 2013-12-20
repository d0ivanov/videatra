require 'warden'
require_relative 'strategies'

module RememberMe

	def self.registered(app)
		app.use Rack::Session::Cookie, :secret => "sajdkfgasdoirqywebKJHSGFweiuobfa"
		Warden::Strategies.add(:remember_me, AuthStrategies::RememberMeStrategy)

		#
		#After user is authenticated with either RememberMe or
		#Password strategy check if he has chosen the remember me
		#option. If he has then set the remember me cookie.
		#
		Warden::Manager.after_authentication do |user, auth, opts|
			if auth.winning_strategy.is_a?(AuthStrategies::RememberMeStrategy) ||
				(auth.winning_strategy.is_a?(AuthStrategies::PasswordStrategy) &&
					auth.params['remember_me'] == "on"
				)
				user.remember_me!
				auth.env['rack.request.cookie_hash'][AuthStrategies::COOKIE_KEY] = {
					:value => user.remember_token,
					:expires => Time.new + 7 * 24 * 3600,
					:path => '/'
				}
			end
		end

		Warden::Manager.before_logout do |user, auth, opts|
			user.forget_me! if user
			auth.env['rack.request.cookie_hash'].delete(AuthStrategies::COOKIE_KEY)
		end
	end
end
