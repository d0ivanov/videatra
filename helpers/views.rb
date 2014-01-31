module Views
  def javascript_include_tag file
    "<script src=\"http://#{request.host_with_port}/js/#{file}\"></script>"
  end

  def stylesheet_include_tag file
    "<link rel=\"stylesheet\" href=\"http://#{request.host_with_port}/stylesheets/#{file}\" type=\"text/css\" />"
  end
end
