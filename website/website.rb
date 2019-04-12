#!/usr/bin/ruby 
require 'sinatra'
require 'haml'
require './rb/template.rb'

def html
  return HtmlTemplate.new
end

set :public_folder, './'

# Endpoints 
get '/' do
  haml :index
end

get '/help' do
  haml :help
end
