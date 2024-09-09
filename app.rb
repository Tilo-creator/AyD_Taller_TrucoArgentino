# app.rb
require 'sinatra'
require 'sinatra/activerecord'
require './models/user'
require './models/lesson'
require './models/question'
require './models/statistic'
require './models/application_record'

set :database_file, './config/database.yml'

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
      @statistic = Statistic.new(cantidadDePreguntaRespondidas: "0", cantPregRespondidasBien: "0", CantPregRespondidasMal:"0", user_id: @user.id)
      @statistic.save
      redirect '/juegos'
    else
      erb :registro, locals: { mensaje: 'Hubo un error al registrar el usuario. Inténtalo de nuevo.' }
    end
  end

  get '/juegos' do
    juegos = ['Truco', 'Poker', 'Escoba']
    erb :juegos, locals: { juegos: juegos }
  end




  get '/juegos/poker' do
    erb :poker # Ruta para cargar la vista poker.erb
  end

  get '/juegos/escoba' do
    erb :escoba # Ruta para cargar la vista .erb
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

  get '/estadisticas' do
    if session[:user_id]
      @user = User.find(session[:user_id])
      @statistic = @user.statistics.last
      erb :estadisticas, locals: { estadistic: @statistic }
    else
      redirect '/login'
    end
  end


  post '/preguntas/responder' do
    if session[:user_id]
      @user = User.find(session[:user_id])
      @statistic = @user.statistics.last
      # Inicializar los contadores si son nil
      @statistic.cantidadDePreguntaRespondidas ||= 0
      @statistic.cantPregRespondidasBien ||= 0
      @statistic.CantPregRespondidasMal ||= 0

      @question = Question.find(params[:pregunta_id])
      if @question.correct_answer?(params[:respuesta])
        @statistic.cantidadDePreguntaRespondidas += 1
        @statistic.cantPregRespondidasBien += 1
        session[:resultado] = "¡Respuesta correcta!"

      else
        @statistic.cantidadDePreguntaRespondidas += 1
        @statistic.CantPregRespondidasMal += 1
        session[:resultado] = "Respuesta incorrecta. La respuesta correcta es: #{@question.correct_answer}"
      end
      @statistic.save
      session[:mostrar_mensaje] = true # Indica que se debe mostrar el mensaje
      redirect '/preguntas'
    else
      redirect '/login'
    end
  end



end





App.run! if __FILE__ == $0