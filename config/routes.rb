class Videatra < Sinatra::Application
  Main = PlugMan.registered_plugins[:main]

	get "/" do
		erb :index
	end

  get /(.*)/ do
    route(:get, params[:captures].first, params)
  end

  post /(.*)/ do
    route(:post, params[:captures].first, params)
  end

  put /(.*)/ do
    route(:put, params[:captures].first, params)
  end

  patch /(.*)/ do
    route(:patch, params[:captures].first, params)
  end

  delete /(.*)/ do
    route(:delete, params[:captures].first, params)
  end

  head /(.*)/ do
    route(:head, params[:captures].first, params)
  end

  options /(.*)/ do
    route(:options, params[:captures].first, params)
  end

  link /(.*)/ do
    route(:link, params[:captures].first, params)
  end

  unlink /(.*)/ do
    route(:unlink, params[:captures].first, params)
  end

  def route method, path, params
    res = nil
    Main.all_plugin_routes.each do |r|
      match_route = if r[2].is_a? String
        path == r[2]
      else
        match = path.match r[2]
        params['captures'] = match if match
        match
      end
      Main.feed_params params
      if r[1].to_s == method.to_s and match_route
        res = PlugMan.registered_plugins[r[0]].send(r[3])
        break
      end
    end
    return res if !res.nil?
    status 404
  end
end
