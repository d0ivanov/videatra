PlugMan.define :test do
  author 'Dobromir Ivanov'
  version '0.0.1'
  extends ({main: [:filter_before_url]})
  requires [:main]
  extension_points []
  params()

end
