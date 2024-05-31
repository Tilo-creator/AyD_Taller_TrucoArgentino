require 'sinatra'
require 'sinatra/base'
require 'sinatra/activerecord'
require './models/user'
require './models/lesson'
require './models/question'
require './models/application_record'
set :database_file, './config/database.yml'

class App < Sinatra::Application
  enable :sessions

  get '/' do 
    erb :inicio
  end 

  get '/login' do
    erb :login
  end

  post '/login' do
    @user = User.find_by(username: params[:username], password: params[:password])
    
    if @user
      session[:user_id] = @user.id
      # Redirigir al usuario según el juego seleccionado
      case params[:juego]
      when 'truco'
        redirect '/juegos/truco'
      when 'poker'
        redirect '/juegos/poker'
      when 'escoba'
        redirect '/juegos/escoba'
      else
        redirect '/juegos'
      end
    else
      'Credenciales incorrectas. Inténtalo de nuevo.' 
    end
  end
  
  get '/perfil' do
    if session[:user_id]
      @user = User.find(session[:user_id])
      erb :perfil, locals: { user: @user }
    else
      redirect '/login'
    end
  end

  get '/entre' do
    "Credenciales válidas"
  end

  get '/lecciones' do
    @lecciones = Lesson.all
    erb :lecciones
  end

  get '/registro' do
    erb :registro
  end

  post '/registro' do
    @user = User.new(names: params[:names], username: params[:username], email: params[:email], password: params[:password])
    
    if @user.save
      session[:user_id] = @user.id
      redirect '/perfil'
    else
      erb :registro, locals: { mensaje: 'Hubo un error al registrar el usuario. Inténtalo de nuevo.' }
    end
  end

  get '/juegos' do
    juegos = ['Truco', 'Poker', 'Escoba']
    erb :juegos, locals: { juegos: juegos }
  end

  get '/juegos/truco' do
    @lessons = Lesson.all
    erb :truco, locals: { lessons: @lessons }
  end

  get '/preguntas' do
    @question = Question.order("RANDOM()").first
    @resultado = session.delete(:resultado)
    erb :preguntas
  end

  post '/preguntas/responder' do
    @question = Question.find(params[:pregunta_id])
    if @question.correct_answer?(params[:respuesta])
      session[:resultado] = "¡Respuesta correcta!"
    else
      session[:resultado] = "Respuesta incorrecta. La respuesta correcta es: #{@question.correct_answer}"
    end
    
    session[:mostrar_mensaje] = true # Indica que se debe mostrar el mensaje
    redirect '/preguntas'
  end
end

App.run! if __FILE__ == $0