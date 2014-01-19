extension_points = [
  :event_before_login_failure,
  :event_before_logout,

  :event_after_set_user,
  :event_after_authentication,
  :event_after_login_failure,
  :event_after_logout,
  :event_after_login,
  :event_after_signup,
]

MAIN.extension_points + extension_points

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
end
