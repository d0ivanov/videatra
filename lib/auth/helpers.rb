module Helpers
  def authenticated?
		env['warden'].authenticated?
  end

  def current_user
    env['warden'].user
  end

	def logout
		env['warden'].logout
  end

	def authenticate!
		env['warden'].authenticate!
	end
end
