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

class Pluginbot < Sinatra::Base
  include Bot::LaunchControl
  include Bot::PluginControl
  include Bot::Routing
  include Bot::UserHandler

  private

  @@html = Bot::HtmlTemplate.new
  @@yml = Bot::YmlTemplate.new
  @@script = Bot::EScript.new

  public

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

  # Endpoints

  get "/*" do
    route = params[:splat].first
    routeGET(route)
  end

  post "/*" do
    route = params[:splat].first
    routePOST(route, params)
  end

  run!
end