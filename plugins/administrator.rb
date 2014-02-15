PlugMan.define :administrator do
  author 'Dobromir Ivanov'
  version '0.0.1'
  extends()
  requires [:main]
  extension_points []
  params()

  Videatra.get '/administrator/' do
    @video_links = Video.all
    erb MAIN.render_path('administrator_layout').to_sym
  end
end
