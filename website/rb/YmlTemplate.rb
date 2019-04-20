require "yaml"
require "digest"

# handling all yml files of the bot
module Bot
  class YmlTemplate
    private

    @path = File.dirname(File.expand_path(__FILE__))
    @@bot_config = "/home/botmaster/src/bot%d_conf.yml"
    @@mpd_config = @path + "/../../plugins/mpd.yml"
    @@youtube_config = @path + "/../../plugins/youtube.yml"
    @@idle_config = @path + "/../../plugins/idle.yml"
    @@mixcloud_config = @path + "/../../plugins/mixcloud.yml"
    @@ektoplazm_config = @path + "/../../plugins/ektoplazm.yml"
    @@bandcamp_config = @path + "/../../plugins/bandcamp.yml"
    @@soundcloud_config = @path + "/../../plugins/soundcloud.yml"
    @@googletts_config = @path + "/../../plugins/googletts.yml"
    @@picotts_config = @path + "/../../plugins/picotts.yml"
    @@login_config = @path + "/../login.yml"
    @@instance_config = @path + "/../../../*_conf.yml"

    def s_true?(str)
      if str == "true" then true else false end
    end

    def s_empty?(str)
      if str == "" then nil else str end
    end

    public

    attr_reader :mpd, :yt, :sc, :bc, :mc, :ep
    attr_reader :gtts, :ptts, :idl, :bots
    attr_accessor :yt_dl

    def initialize
      loadYaml()

      #for simpler using it in haml
      @mpd = @mpd_file["plugin"]["mpd"]
      @yt = @youtube["plugin"]["youtube"]
      @sc = @soundcloud["plugin"]["soundcloud"]
      @bc = @bandcamp["plugin"]["bandcamp"]
      @mc = @mixcloud["plugin"]["mixcloud"]
      @ep = @ektoplazm["plugin"]["ektoplazm"]
      @idl = @idle["plugin"]["idle"]
      @ptts = @picotts["plugin"]["picotts"]
      @gtts = @googletts["plugin"]["googletts"]
      @yt_dl = nil # is set on get

      getInstances()
    end

    def loadYaml()
      @mpd_file = YAML.load_file(@@mpd_config)
      @youtube = YAML.load_file(@@youtube_config)
      @idle = YAML.load_file(@@idle_config)
      @mixcloud = YAML.load_file(@@mixcloud_config)
      @ektoplazm = YAML.load_file(@@ektoplazm_config)
      @bandcamp = YAML.load_file(@@bandcamp_config)
      @soundcloud = YAML.load_file(@@soundcloud_config)
      @googletts = YAML.load_file(@@googletts_config)
      @picotts = YAML.load_file(@@picotts_config)
    end

    def getInstances
      @path = File.dirname(File.expand_path(__FILE__))
      @bots_path = Dir[@@instance_config]
      @bots = []
      @bots_path.each { |p| @bots.push(YAML.load_file(p)) }
    end

    def setBot(session)
      if (session[:bot] == nil)
        session[:bot] = @bots[0]
      end
    end

    # TODO exception block
    def load_log(bot)
      f = bot["main"]["logfile"]
      if (f == nil)
        return "No path to logfile"
      end
      if (File.file?(f))
        File.read(bot["main"]["logfile"])
      else
        return "A log file does not exist"
      end
    end

    def login(usr, pwd)
      pwd = Digest::SHA512.hexdigest pwd
      @login = YAML.load_file(@@login_config)

      for obj in @login["login"]
        if (obj["usr"] == usr && obj["pwd"] == pwd)
          return true
        end
      end
      return false
    end

    def writeYtDl(params)
      @yt_dl["path"] = s_empty? params["ytdl_path"]
      @yt_dl["options"] = s_empty? params["ytdl_options"]
      @yt_dl["prefixes"] = s_empty? params["ytdl_prefixes"]
    end

    def writeBack(yml, params)
      yml["youtube_dl"] = @yt_dl

      yml["folder"]["download"] = s_empty? params["folder_download"]
      yml["folder"]["temp"] = s_empty? params["folder_temp"]
      yml["to_mp3"] = s_true?(params["to_mp3"])
    end

    def saveYoutube(params)
      writeYtDl(params)
      @yt_dl["maxresults"] = params["ytdl_maxresults"].to_i
      @yt["youtube_dl"] = @yt_dl

      @yt["folder"]["download"] = s_empty? params["folder_download"]
      @yt["folder"]["temp"] = s_empty? params["folder_temp"]
      @yt["stream"] = s_empty?(params["stream"])
      puts params["to_mp3"]
      @yt["to_mp3"] = s_true?(params["to_mp3"])

      @youtube["plugin"]["youtube"] = @yt
      File.open(@@youtube_config, "w") { |f| f.write @youtube.to_yaml }
    end

    def saveMpd(post)
      @mpd["testpipe"] = s_true?(post["testpipe"])
      @mpd["volume"] = post["volume"].to_i
      @mpd["host"] = s_empty? post["host"]
      @mpd["port"] = post["port"].to_i
      @mpd["musicfolder"] = s_empty? post["musicfolder"]
      @mpd["template"]["comment"]["enabled"] = s_empty? post["enabled"]
      @mpd["template"]["comment"]["disabled"] = s_empty? post["disabled"]

      @mpd_file["plugin"]["mpd"] = @mpd
      File.open(@@mpd_config, "w") { |f| f.write @mpd_file.to_yaml }
    end

    def saveSoundCloud(post)
      writeYtDl(post)
      writeBack(@sc, post)
      @soundcloud["plugin"]["soundcloud"] = @sc
      File.open(@@soundcloud_config, "w") { |f| f.write @soundcloud.to_yaml }
    end

    def saveMixCloud(post)
      writeYtDl(post)
      writeBack(@mc, post)
      @mixcloud["plugin"]["mixcloud"] = @mc
      File.open(@@mixcloud_config, "w") { |f| f.write @mixcloud.to_yaml }
    end

    def saveMixCloud(post)
      writeYtDl(post)
      writeBack(@mc, post)
      @mixcloud["plugin"]["mixcloud"] = @mc
      File.open(@@mixcloud_config, "w") { |f| f.write @mixcloud.to_yaml }
    end

    def saveBandCamp(post)
      writeYtDl(post)
      writeBack(@bc, post)
      @bandcamp["plugin"]["bandcamp"] = @bc
      File.open(@@bandcamp_config, "w") { |f| f.write @bandcamp.to_yaml }
    end

    def saveEktoplazm(post)
      @ep["folder"]["download"] = s_empty? params["folder_download"]
      @ep["folder"]["temp"] = s_empty? params["folder_temp"]
      @ep["prefixes"] = s_empty? params["prefixes"]

      @ektoplazm["plugin"]["ektoplazm"] = @ep
      File.open(@@ektoplazm_config, "w") { |f| f.write @ektoplazm.to_yaml }
    end

    def saveGoogleTTS(post)
      @googletts["plugin"]["googletts"]["lang"] = s_empty? post["lang"]
      File.open(@@googletts_config, "w") { |f| f.write @googletts.to_yaml }
    end

    def savePicoTTS(post)
      @picotts["plugin"]["picotts"]["lang"] = s_empty? post["lang"]
      File.open(@@picotts_config, "w") { |f| f.write @picotts.to_yaml }
    end

    def saveIdle(post)
      @idl["maxidletime"] = post["maxidletime"].to_i
      @idl["idleaction"] = s_empty? post["idleaction"]
      @idle["plugin"]["idle"] = @idl
      File.open(@@idle_config, "w") { |f| f.write @idle.to_yaml }
    end

    def saveBot(post, session)
      pos = 0
      for b in @bots
        break if b == session[:bot]
        pos += 1
      end

      puts post

      bot = @bots[pos]
      bot["debug"] = s_true?(post["debug"])
      bot["language"] = s_empty? post["lang"]
      bot["main"]["logfile"] = post["logfile"]
      bot["main"]["ducking"] = s_true?(post["ducking"])
      bot["main"]["automute_if_alone"] = s_true?(post["automute_if_alone"])
      bot["main"]["stop_on_unregistered"] = s_true?(post["stop_on_unregistered"])
      bot["main"]["whitelist_enabled"] = s_true?(post["whitelist_enabled"])
      bot["main"]["fifo"] = s_empty? post["fifo"]
      bot["main"]["control"]["string"] = s_empty? post["string"]
      bot["main"]["control"]["message"]["private_only"] = s_empty? post["private_only"]
      bot["main"]["control"]["message"]["registred_only"] =
        s_true?(post["registered_only"])
      bot["main"]["control"]["historysize"] = post["historysize"].to_i
      bot["main"]["user"]["whitelisted"] = s_empty? post["whitelisted"]
      bot["main"]["user"]["superuser"] = s_empty? post["superuser"]
      bot["main"]["user"]["banned"] = s_empty? post["banned"]
      bot["main"]["user"]["bound"] = s_empty? post["bound"]
      bot["mumble"]["name"] = s_empty? post["name"]
      bot["mumble"]["host"] = s_empty? post["host"]
      bot["mumble"]["port"] = post["port"].to_i
      bot["mumble"]["password"] = s_empty? post["password"]
      bot["mumble"]["use_vbr"] = post["use_vbr"].to_i

      File.open(@bots_path[pos], "w") { |f| f.write bot.to_yaml }
      @bots[pos] = bot
      session[:bot] = bot
    end
  end
end
