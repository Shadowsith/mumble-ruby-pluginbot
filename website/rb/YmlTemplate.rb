require 'yaml'

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
  @@googletts_config = @path + "/../../plugins/googletts.yml"
  @@picotts__config = @path + "/../../plugins/picotts.yml"

  def setupValuesForWeb
    if @yt['to_mp3'] == true
      @yt['to_mp3'] = 1
    else 
      @yt['to_mp3'] = 0
    end
  end

  public
  def initialize
    #load yaml
    @mpd = YAML.load_file(@@mpd_config)
    @youtube = YAML.load_file(@@youtube_config)
    @idle = YAML.load_file(@@idle_config)
    @mixcloud = YAML.load_file(@@mixcloud_config)
    @ektoplazm = YAML.load_file(@@ektoplazm_config)
    @bandcamp = YAML.load_file(@@bandcamp_config)
    @googletts = YAML.load_file(@@googletts_config)
    @picotts = YAML.load_file(@@picotts__config)

    #for simpler using it in haml
    @yt = @youtube['plugin']['youtube']
    @yt_dl = @yt['youtube_dl']

    setupValuesForWeb()
  end

  attr_reader :mpd, :yt, :yt_dl, :idle, :mixcloud, :ektoplazm
  attr_reader :bandcamp, :googletts, :picotts
end
