require_relative "./SessionHandler.rb"
require_relative "./UserHandler.rb"

module Bot
  module Routing
    include SessionHandler
    include UserHandler

    def routed?(route)
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

    def GET(route)
      if (route != "login")
        session[:index_content] = route
        redirect "/login" if session[:login] != true
      end

      if (!routed?(route))
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
          SessionHandler.logout(session)
          script.store_call("$.announce.info('Logged Out!')")
          redirect "/login"
        else
          redirect "/index" if session[:login]
          redirect "/login"
        end
      end
    end

    def POST(route, post)
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
          LaunchControl.start_bots()
          script.store_call("$.announce.success('Bots started!');")
          redirect "/index"
        when "bot_stop"
          LaunchControl.stop_bots()
          script.store_call("$.announce.warning('Bots stopped!');")
          redirect "/index"
        when "acc_change"
          changeUserSettings(post, session)
          redirect "/index"
        when "acc_add"
          addUser(post, session)
        when "acc_del"
          deleteUser(post, session)
        when "acc_cadmin"
          changeUsrByAdmin(post, session)
        else
          redirect "/index"
          return
        end
        redirect "/#{route}"
      else
        if (route == "login")
          SessionHandler.login(self, session, post)
        end
      end
    end
  end
end
