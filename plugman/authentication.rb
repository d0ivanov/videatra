extension_points = [
  :event_after_set_user,
  :event_after_authentication,
  :event_before_login_failure,
  :event_after_login_failure,
  :event_before_logout,
  :event_after_logout,
  :event_after_login,
  :event_after_signup,
  :filter_after_logout_path,
  :filter_after_login_path,
  :filter_after_signup_path
]

resources = {
  after_logout_path: '/',
  after_logout_msg: 'Successfully logged out!',
  after_login_path: '/',
  after_login_msg: 'Successfully logged in!',
  after_signup_path: '/'
  after_signup_msg: 'Successfully signed up!'
}

MAIN.extension_points += extension_points
MAIN.resources += resources


# we wrap the hooks in a method, so that they can be reinitialized when
# we call reload plugins
def auth_hooks
  # events
  Authstrategies::Manager.after_set_user do |user, auth, opts|
    MAIN.call :event_after_set_user, user, auth, opts
  end

  Authstrategies::Manager.after_authentication do |user, auth, opts|
    MAIN.call :event_after_authentication, user, auth, opts
  end

  Authstrategies::Manager.before_login_failure do |env, opts|
    MAIN.call :event_before_login_failure, env, opts
  end

  Authstrategies::Manager.after_login_failure do
    MAIN.call :event_after_login_failure
  end

  Authstrategies::Manager.before_logout do |user, auth, opts|
    MAIN.call :event_before_logout, user, auth, opts
  end

  Authstrategies::Manager.after_logout do
    MAIN.call :event_after_logout
  end

  Authstrategies::Manager.after_login do
    MAIN.call :event_after_login
  end

  Authstrategies::Manager.after_signup do
    MAIN.call :event_after_signup
  end

  # filters
  # This three filter functions, when defined in client plugins should return an
  # array with [path, message]

  Authstrategies::Manager.config[:after_logout_path] = *MAIN.get(:filter_after_logout_path)
  Authstrategies::Manager.config[:after_logout_msg] = *MAIN.get(:filter_after_logout_msg)

  Authstrategies::Manager.config[:after_login_path] = *MAIN.get(:filter_after_login_path)
  Authstrategies::Manager.config[:after_login_msg] = *MAIN.get(:filter_after_login_msg)

  Authstrategies::Manager.config[:after_signup_path] = *MAIN.get(:filter_after_signup_path)
  Authstrategies::Manager.config[:after_signup_msg] = *MAIN.get(:filter_after_signup_msg)
end
