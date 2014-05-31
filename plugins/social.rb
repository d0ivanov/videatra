PlugMan.define :social do
  author 'Dobromir Ivanov'
  version '0.0.1'
  extends ({main: [:filter_video_social, :filter_body_main]})
  requires [:main]
  extension_points []
  params()

  def filter_body_main
    "<div id=\"fb-root\"></div>
      <script>(function(d, s, id) {
        var js, fjs = d.getElementsByTagName(s)[0];
        if (d.getElementById(id)) return;
        js = d.createElement(s); js.id = id;
        js.src = \"//connect.facebook.net/en_GB/sdk.js#xfbml=1&version=v2.0\";
        fjs.parentNode.insertBefore(js, fjs);
      }(document, 'script', 'facebook-jssdk'));</script>"
  end

  def filter_video_social video, user
    "<li>
    <div class=\"fb-like\" width=\"120px\" data-href=\"https://developers.facebook.com/docs/plugins/\" data-layout=\"standard\" data-action=\"like\" data-show-faces=\"false\" data-share=\"true\"></div>
      </li>
    <li>
      <div class=\"g-plusone\" data-size=\"medium\" data-annotation=\"inline\" data-width=\"120\"></div>
    </li>
    <script type=\"text/javascript\">
      window.___gcfg = {lang: 'bg'};

      (function() {
        var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
        po.src = 'https://apis.google.com/js/platform.js';
        var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
      })();
    </script>
    "
  end
end
