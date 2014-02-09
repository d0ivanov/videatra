PlugMan.define :guardian do
  author 'Dobromir Ivanov'
  version '0.0.1'
  extends ({main: [:filter_before_route]})
  requires [:main]
  extension_points [:filter_conditions, :event_filter_failed]
  params()

  def filter_before_route current_user, path, params, response
    PlugMan.extensions(:guardian, :filter_conditions).each do |plugin|
      if !plugin.filter_conditions current_user, path, params
        plugin.event_filter_failed path, response
      end
    end
  end
end
