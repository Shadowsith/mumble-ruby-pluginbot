require_relative "./SessionHandler.rb"

module Bot
  module Routing
    include SessionHandler

    def routeBot(route)
      for b in yml.bots
        if route == b["mumble"]["name"]
          session[:bot] = b
          session[:index_content] = "global"
          redirect "/index"
          return true
        end
      end
      return false
    end

    def routeGET(route)
      puts "Route: #{route}"
      if (route != "login")
        session[:index_content] = route
        redirect "/login" if session[:login] != true
      end

      isRouted = routeBot(route)

      if (!isRouted)
        case route
        when "login"
          redirect "/index" if session["login"] == true
          haml :login
        when "index"
          session[:index_content] = "global"
          haml :index
        when "youtube"
          yml.yt_dl = yml.yt["youtube_dl"]
          haml :index
        when "mpd"
          haml :index
        when "ektoplazm"
          haml :index
        when "bandcamp"
          yml.yt_dl = yml.bc["youtube_dl"]
          haml :index
        when "mixcloud"
          yml.yt_dl = yml.mc["youtube_dl"]
          haml :index
        when "soundcloud"
          yml.yt_dl = yml.sc["youtube_dl"]
          haml :index
        when "idle"
          haml :index
        when "googletts"
          haml :index
        when "picotts"
          haml :index
        when "log"
          haml :index
        when "plugins"
          haml :index
        when "logout"
          logout(session)
          redirect "/login"
        else
          redirect "/index" if session[:login]
          redirect "/login"
        end
      end
    end

    def routePOST(route, post)
      if (session[:login])
        case route
        when "youtube"
          yml.saveYoutube(post)
        when "mpd"
          yml.saveMpd(post)
        when "soundcloud"
          yml.saveSoundCloud(post)
        when "mixcloud"
          yml.saveMixCloud(post)
        when "bandcamp"
          yml.saveBandCamp(post)
        when "ektoplazm"
          yml.saveEktoplazm(post)
        when "googletts"
          yml.saveGoogleTTS(post)
        when "picotts"
          yml.savePicoTTS(post)
        when "idle"
          yml.saveIdle(post)
        when "index"
          yml.saveBot(post, session)
        when "bot_start"
          start_bots()
          script.store_call("$.announce.success('Bots started!');")
          redirect "/index"
        when "bot_stop"
          stop_bots()
          script.store_call("$.announce.warning('Bots stopped!');")
          redirect "/index"
        else
          redirect "/index"
          return
        end
        redirect "/#{route}"
      else
        if (route == "login")
          login(post)
        end
      end
    end
  end
end
