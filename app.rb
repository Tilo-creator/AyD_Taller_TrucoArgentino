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
    erb:'/inicio'
  end 

  get '/login' do
    erb:login
  end

  post '/login' do
    # Busca un usuario en la base de datos con el email y contraseña proporcionados
    @user = User.find_by(username: params[:username], password: params[:password])
    
    # Verifica si se encontró un usuario con los datos proporcionados
    if @user
      # Si se encuentra, inicia sesión guardando su ID en la sesión
      session[:user_id] = @user.id
      redirect '/entre' # Redirige al perfil del usuario
    else
      'Credenciales incorrectas. Inténtalo de nuevo.' 
    end
  end

  get '/perfil' do
    # Verifica si hay un usuario iniciado sesión
    if session[:user_id]
      'hola '
      # Busca el usuario en la base de datos utilizando su ID guardado en la sesión
      @user = User.find(session[:user_id])
      erb :perfil, locals: { user: @user } # Muestra la página del perfil
    else
      redirect '/login' # Si no hay sesión iniciada, redirige al inicio de sesión
    end
  end
  
  get '/entre' do
    "credenciales validas"
  end


end