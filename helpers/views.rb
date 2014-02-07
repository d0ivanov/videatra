require_relative "country"

module Views
  def javascript_include_tag file
    "<script src=\"http://#{request.host_with_port}/js/#{file}\"></script>"
  end

  def stylesheet_include_tag file
    "<link rel=\"stylesheet\" href=\"http://#{request.host_with_port}/stylesheets/#{file}\" type=\"text/css\" />"
  end

  def page
    [params[:page].to_i - 1, 0].max
  end

  def country_select
    Country.to_select
  end

  def selected_country code
    Country[code.to_sym]  if not code.to_s.empty?
  end
end
