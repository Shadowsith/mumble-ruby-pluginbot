#!/usr/bin/ruby
require "sinatra/base"
require "haml"
require_relative "./rb/HtmlTemplate.rb"
require_relative "./rb/YmlTemplate.rb"
require_relative "./rb/LaunchControl.rb"

class Pluginbot < Sinatra::Base
  include Bot::LaunchControl

  private

  @@html = Bot::HtmlTemplate.new
  @@yml = Bot::YmlTemplate.new

  public

  set :public_folder, File.dirname(File.expand_path(__FILE__)) + "/"
  enable :sessions

  def login(params)
    usr = params[:username]
    pwd = params[:password]
    # dummy test 'login'
    if (@@yml.login(usr, pwd))
      session[:login] = true
      session[:usr] = usr
      yml.setBot(session)
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

  def setContent(content)
    session[:index_content] = content
    session[:last_visit] = content
  end

  def setRoute(route)
    if (route != "login")
      redirect "/login" if session[:login] != true
      session[:index_content] = route
    end

    isRouted = false

    # dynamic bot sessions
    for b in yml.bots
      if route == b["mumble"]["name"]
        session[:bot] = b
        isRouted = true
        session[:index_content] = "global"
        redirect "/index"
        return
      end
    end

    if (!isRouted)
      case route
      when "login"
        redirect "/index" if session["login"] == true
        haml :login
      when "index"
        setContent("global")
        haml :index
      when "youtube"
        setContent("youtube")
        @@yml.yt_dl = @@yml.yt["youtube_dl"]
        haml :index
      when "mpd"
        setContent("mpd")
        haml :index
      when "ektoplazm"
        setContent("ektoplazm")
        haml :index
      when "bandcamp"
        setContent("bandcamp")
        @@yml.yt_dl = @@yml.bc["youtube_dl"]
        haml :index
      when "mixcloud"
        setContent("mixcloud")
        @@yml.yt_dl = @@yml.mc["youtube_dl"]
        haml :index
      when "soundcloud"
        setContent("soundcloud")
        @@yml.yt_dl = @@yml.sc["youtube_dl"]
        haml :index
      when "idle"
        setContent("idle")
        haml :index
      when "googletts"
        setContent("googletts")
        haml :index
      when "picotts"
        setContent("picotts")
        haml :index
      when "log"
        setContent("log")
        haml :index
      when "logout"
        session[:login] = false
        session[:usr] = nil
        redirect "/login"
      else
        haml :login
      end
    end
  end

  def handlePost(route, post)
    if (session[:login])
      case route
      when "youtube"
        @@yml.saveYoutube(post)
      when "mpd"
        @@yml.saveMpd(post)
      when "soundcloud"
        @@yml.saveSoundCloud(post)
      when "mixcloud"
        @@yml.saveMixCloud(post)
      when "bandcamp"
        @@yml.saveBandCamp(post)
      when "ektoplazm"
        @@yml.saveEktoplazm(post)
      when "googletts"
        @@yml.saveGoogleTTS(post)
      when "picotts"
        @@yml.savePicoTTS(post)
      when "idle"
        @@yml.saveIdle(post)
      when "index"
        @@yml.saveBot(post, session)
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

  # Endpoints

  get "/*" do
    route = params[:splat].first
    setRoute(route)
  end

  post "/*" do
    route = params[:splat].first
    handlePost(route, params)
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
    @@yml.saveBot(params, session)
    redirect "/index"
  end

  post "/bot_start" do
    start_bots()
    redirect "/index"
  end

  post "/bot_stop" do
    stop_bots()
    redirect "index"
  end

  post "/bot_ytldl" do
    update_ytdl()
  end

  run!
end
