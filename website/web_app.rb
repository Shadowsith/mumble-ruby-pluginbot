#!/usr/bin/ruby
require "sinatra/base"
require "haml"
require_relative "./rb/HtmlTemplate.rb"
require_relative "./rb/YmlTemplate.rb"
require_relative "./rb/LaunchControl.rb"
require_relative "./rb/PluginControl.rb"
require_relative "./rb/EScript.rb"
require_relative "./rb/Routing.rb"
require_relative "./rb/UserHandler.rb"
require_relative "./rb/WebConsole.rb"

class Pluginbot < Sinatra::Base
  include Bot::Routing

  private

  @@html = Bot::HtmlTemplate.new
  @@yml = Bot::YmlTemplate.new
  @@script = Bot::EScript.new
  @@plugins = Bot::PluginControl.new
  @@console = Bot::WebConsole.new

  @@msgBox = {
    :txt => "",
    :btn => "",
    :type => "",
    :event => "",
  }

  public

  def getMsgBox()
    return @@msgBox
  end

  def setMsgBox(txt, btn, type, e)
    @@msgBox[:txt] = txt
    @@msgBox[:btn] = btn
    @@msgBox[:type] = type
    @@msgBox[:event] = e
  end

  set :public_folder, File.dirname(File.expand_path(__FILE__)) + "/"
  enable :sessions

  def script
    return @@script
  end

  def html
    return @@html
  end

  def yml
    return @@yml
  end

  def plugins
    return @@plugins
  end

  def console
    return @@console
  end

  # Endpoints

  get "/*" do
    route = params[:splat].first
    GET(route)
  end

  post "/*" do
    route = params[:splat].first
    POST(route, params)
  end

  run!
end
