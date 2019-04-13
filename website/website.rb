#!/usr/bin/ruby 
require 'sinatra/base'
require 'haml'
require_relative './rb/HtmlTemplate.rb'
require_relative './rb/YmlTemplate.rb'

class Pluginbot < Sinatra::Base
  private
  @@html = HtmlTemplate.new
  @@yml = YmlTemplate.new

  public
  set :public_folder, File.dirname(File.expand_path(__FILE__)) + '/'
  def login(params)
    usr = params['username']
    pwd = params['password']
    # dummy test 'login'
    if (usr == 'hello' && pwd == 'world')
      haml :index
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
  
  # Endpoints
  get '/' do
    haml :login
  end

  get '/index' do
    @index_content = 'global'
    haml :index 
  end

  get '/youtube' do 
    @index_content = 'youtube'
    haml :index
  end

  get '/login' do
    haml :login
  end

  post '/' do 
    login(params)
  end

  post '/login' do
    login(params)
  end

  get '/help' do
    haml :help
  end

  run!
end
