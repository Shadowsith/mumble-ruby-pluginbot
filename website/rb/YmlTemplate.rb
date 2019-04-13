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
  @@soundcloud_config = @path + "/../../plugins/soundcloud.yml"
  @@googletts_config = @path + "/../../plugins/googletts.yml"
  @@picotts__config = @path + "/../../plugins/picotts.yml"

  public
  attr_reader :mpd, :yt, :yt_dl, :sc, :bc, :mc, :ep
  attr_reader :googletts, :picotts
  attr_writer :yt_dl

  def initialize
    puts 'hi'
    #load yaml
    @mpd_file = YAML.load_file(@@mpd_config)
    @youtube = YAML.load_file(@@youtube_config)
    @idle = YAML.load_file(@@idle_config)
    @mixcloud = YAML.load_file(@@mixcloud_config)
    @ektoplazm = YAML.load_file(@@ektoplazm_config)
    @bandcamp = YAML.load_file(@@bandcamp_config)
    @soundcloud = YAML.load_file(@@soundcloud_config)
    @googletts = YAML.load_file(@@googletts_config)
    @picotts = YAML.load_file(@@picotts__config)

    #for simpler using it in haml
    @mpd = @mpd_file['plugin']['mpd']
    @yt = @youtube['plugin']['youtube']
    @sc = @soundcloud['plugin']['soundcloud']
    @bc = @bandcamp['plugin']['bandcamp']
    @mc = @mixcloud['plugin']['mixcloud'] 
    @ep = @ektoplazm['plugin']['ektoplazm']
    @yt_dl = nil # is set on get
  end

  def writeYtDl(params) 
    @yt_dl['path'] = params['ytdl_path']
    @yt_dl['options'] = params['ytdl_options']
    @yt_dl['prefixes'] = params['ytdl_prefixes']
  end

  def writeBack(yml, params)
    yml['youtube_dl'] = @yt_dl

    yml['folder']['download'] = params['folder_download']
    yml['folder']['temp'] = params['folder_temp']
    if params['to_mp3'] == '1'
      yml['to_mp3'] = true
    else
      yml['to_mp3'] = false
    end
  end

  def saveYoutube(params)
    writeYtDl(params)
    @yt_dl['maxresults'] = params['ytdl_maxresults']
    @yt['youtube_dl'] = @yt_dl

    @yt['folder']['download'] = params['folder_download']
    @yt['folder']['temp'] = params['folder_temp']
    @yt['stream'] = params['stream']
    if params['to_mp3'] == 1
      @yt['to_mp3'] == true
    else
      @yt['to_mp3'] == false
    end

    @youtube['plugin']['youtube'] = @yt
    File.open(@@youtube_config, 'w') {|f| f.write @youtube.to_yaml}
  end

  def saveMpd(post)
    @mpd['testpipe'] = post['testpipe']
    @mpd['volume'] = post['volume']
    @mpd['host'] = post['host']
    @mpd['port'] = post['port']
    @mpd['musicfolder'] = post['musicfolder']
    @mpd['template']['comment']['enabled'] = post['enabled']
    @mpd['template']['comment']['disabled'] = post['disabled']
    
    @mpd_file['plugin']['mpd'] = @mpd
    File.open(@@mpd_config, 'w') {|f| f.write @mpd_file.to_yaml} 
  end

  def saveSoundCloud(post)
    writeYtDl(post)
    writeBack(@sc, post)
    @soundcloud['plugin']['soundcloud'] = @sc
    File.open(@@soundcloud_config, 'w') {|f| f.write @soundcloud.to_yaml} 
  end

  def saveMixCloud(post)
    writeYtDl(post)
    writeBack(@mc, post)
    @mixcloud['plugin']['mixcloud'] = @mc
    File.open(@@mixcloud_config, 'w') {|f| f.write @mixcloud.to_yaml} 
  end

  def saveMixCloud(post)
    writeYtDl(post)
    writeBack(@mc, post)
    @mixcloud['plugin']['mixcloud'] = @mc
    File.open(@@mixcloud_config, 'w') {|f| f.write @mixcloud.to_yaml} 
  end

  def saveBandCamp(post)
    writeYtDl(post)
    writeBack(@bc, post)
    @bandcamp['plugin']['bandcamp'] = @bc
    File.open(@@bandcamp_config, 'w') {|f| f.write @bandcamp.to_yaml} 
  end

  def saveEktoplazm(post)
    @ep['folder']['download'] = params['folder_download']
    @ep['folder']['temp'] = params['folder_temp']
    @ep['prefixes'] = params['prefixes']

    @ektoplazm['plugin']['ektoplazm'] = @ep
    File.open(@@ektoplazm_config, 'w') {|f| f.write @ektoplazm.to_yaml} 
  end

  def saveGoogleTTS(post)
    @googletts['lang'] = post['lang']
    File.open(@@googletts_config, 'w') {|f| f.write @googletts.to_yaml} 
  end

  def savePicoTTS(post)
    @picotts['lang'] = post['lang']
    File.open(@@picotts_config, 'w') {|f| f.write @picotts.to_yaml} 
  end
end
