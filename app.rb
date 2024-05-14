require'sinatra'
require 'sinatra/base'
require 'sinatra/activerecord'
require './models/user'
set :database_file, './config/database.yml'


class App < Sinatra::Application
  def initialize(app = nil)
    super()
  end

  get '/' do
    'Welcome tilo'
  end

  get '/users' do
    @users = User.all
    erb :'users/index'
  end
end