PlugMan.define :video_colaborator do
  author 'Dobromir Ivanov'
  version '0.0.1'
  extends ({guardian: [:filter_conditions, :event_filter_failed]})
  requires [:rolify]
  extension_points []
  params()

   filter_by_role = Proc.new { |user, path|
    (user && !(user.user_roles & ["admin", "colaborator"]).empty?)
  }

  @protected_routes = {
    "/videos/upload/?"   => filter_by_role,
    "/videos/edit/:id/?" => filter_by_role,
    "/videos/delete/:id" => filter_by_role
  }

  def filter_conditions current_user, path
    return true if (filter = @protected_routes[path]).nil?
    return filter.call(current_user, path)
  end

  def event_filter_failed path, response
    response.redirect "/login"
  end
end
