#!/usr/bin/ruby
require "sinatra/base"
require "haml"
require_relative "./rb/HtmlTemplate.rb"
require_relative "./rb/YmlTemplate.rb"

class Pluginbot < Sinatra::Base
  private

  @@html = HtmlTemplate.new
  @@yml = YmlTemplate.new

  public

  set :public_folder, File.dirname(File.expand_path(__FILE__)) + "/"
  enable :sessions

  def login(params)
    usr = params["username"]
    pwd = params["password"]
    # dummy test 'login'
    if (@@yml.login(usr, pwd))
      session["login"] = true
      session["usr"] = usr
      redirect "/index"
    else
      haml :login
    end
  end

  def html
    return @@html
  end

  def yml
    return @@yml
  end

  def setRoute(route)
    if (route != "login")
      redirect "/login" if session["login"] != true
      @index_content = route
    end

    isRouted = false

    # dynamic bot sessions
    for b in yml.bots
      if route == b["mumble"]["name"]
        yml.sel_bot = b
        isRouted = true
        @index_content = "global"
        redirect "/index"
        break
      end
    end

    if (!isRouted)
      case route
      when "login"
        redirect "/index" if session["login"] == true
        haml :login
      when "index"
        @index_content = "global"
        haml :index
      when "youtube"
        @@yml.yt_dl = @@yml.yt["youtube_dl"]
        haml :index
      when "mpd"
        haml :index
      when "ektoplazm"
        haml :index
      when "bandcamp"
        @@yml.yt_dl = @@yml.bc["youtube_dl"]
        haml :index
      when "mixcloud"
        @@yml.yt_dl = @@yml.mc["youtube_dl"]
        haml :index
      when "soundcloud"
        @@yml.yt_dl = @@yml.sc["youtube_dl"]
        haml :index
      when "idle"
        haml :index
      when "googletts"
        haml :index
      when "picotts"
        haml :index
      when "logout"
        session["login"] = false
        session["usr"] = nil
        puts session
        redirect "/login"
      else
        haml :login
      end
    end
  end

  # Endpoints

  get "/*" do
    route = params[:splat].first
    setRoute(route)
  end

  post "/login" do
    login(params)
  end

  post "/youtube" do
    @@yml.saveYoutube(params)
    redirect "/youtube"
  end

  post "/mpd" do
    @@yml.saveMpd(params)
    redirect "/mpd"
  end

  post "/soundcloud" do
    @@yml.saveSoundCloud(params)
    redirect "/soundcloud"
  end

  post "/mixcloud" do
    @@yml.saveMixCloud(params)
    redirect "/mixcloud"
  end

  post "/bandcamp" do
    @@yml.saveBandCamp(params)
    redirect "/bandcamp"
  end

  post "/ektoplazm" do
    @@yml.saveEktoplazm(params)
    redirect "/ektoplazm"
  end

  post "/googletts" do
    @@yml.saveGoogleTTS(params)
    redirect "/googletts"
  end

  post "/picotts" do
    @@yml.savePicoTTS(params)
    redirect "/picotts"
  end

  post "/idle" do 
    @@yml.saveIdle(params)
  end

  post "/index" do
      @@yml.saveBot(params)
      redirect "/index"
  end

  run!
end
