# frozen_string_literal: true

require './models/user'
require './models/lesson'
require './models/question'
require './models/statistic'
require './models/life'
require './models/application_record'
require './models/level'
# controlador de vistas de login/registro
class UserController < Sinatra::Base
  enable :sessions

  configure do
    set :views, './views'
  end
  get '/login' do
    erb :login
  end

  post '/login' do
    if params[:password] == params[:confirm_password]
      @user = User.new(
        names: params[:names],
        username: params[:username],
        email: params[:email],
        password: params[:password]
      )
      if @user.save
        # Crear un nivel inicial para el usuario con level_number en 1
        session[:user_id] = @user.id
        @statistic = Statistic.new(cantidadDePreguntaRespondidas: "0", cantPregRespondidasBien: "0", cantPregRespondidasMal:"0",total_points: "0", user_id: @user.id)
        @statistic.save
        @life = Life.new(cantidadDeVidas: "3", user_id: @user.id)
        @life.save
        @level = Level.new(level_number: 1,user_id: @user.id)
        @level.save
        redirect '/juegos'
      else
        erb :login, locals: { mensaje: 'Hubo un error al crear tu cuenta. Inténtalo de nuevo.' }
      end
    else
      erb :login, locals: { mensaje: 'Las contraseñas no coinciden. Inténtalo de nuevo.' }
    end
  end

  get '/perfil' do
    if session[:user_id]
      @user = User.find(session[:user_id])
      erb :perfil, locals: { user: @user }
    else
      redirect '/'
    end
  end
end
