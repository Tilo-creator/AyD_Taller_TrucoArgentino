require 'sinatra'
require 'sinatra/activerecord'
require './models/user'
require './models/lesson'
require './models/question'
require './models/statistic'
require './models/application_record'

set :database_file, './config/database.yml'

class App < Sinatra::Application
  enable :sessions

  get '/' do 
    erb :inicio
  end 

  post '/' do
    if params[:action] == 'login'
      # Manejo del inicio de sesión
      @user = User.find_by(username: params[:username], password: params[:password])
      
      if @user
        session[:user_id] = @user.id
        redirect '/juegos'
      else
        erb :inicio, locals: { mensaje: 'Credenciales incorrectas. Inténtalo de nuevo.' }
      end
    elsif params[:action] == 'register'
      redirect '/login'  # Redirige a la página de registro
    end
  end

  # Ruta para el formulario de registro
  get '/login' do
    erb :login  # Vista para el formulario de registro
  end

  # Ruta para manejar la creación de usuarios
  post '/login' do
    if params[:password] == params[:confirm_password]
      @user = User.new(
        fullname: params[:fullname],
        username: params[:username],
        email: params[:email],
        password: params[:password]
      )
      if @user.save
        session[:user_id] = @user.id
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

  get '/juegos' do
    juegos = ['Truco', 'Poker', 'Escoba']
    erb :juegos, locals: { juegos: juegos }
  end

  get '/juegos/poker' do
    erb :poker
  end

  get '/juegos/escoba' do
    erb :escoba
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
      redirect '/'
    end
  end

  post '/preguntas/responder' do
    if session[:user_id]
      @user = User.find(session[:user_id])
      @statistic = @user.statistics.last
      # Inicializar los contadores si son nil
      @statistic.cantidadDePreguntaRespondidas ||= 0
      @statistic.cantPregRespondidasBien ||= 0
      @statistic.CantPregRespondidasMal ||= 0  # Corrige el nombre aquí
      @question = Question.find(params[:pregunta_id])
      if @question.correct_answer?(params[:respuesta])
        @statistic.cantidadDePreguntaRespondidas += 1
        @statistic.cantPregRespondidasBien += 1
        session[:resultado] = "¡Respuesta correcta!"
      else
        @statistic.cantidadDePreguntaRespondidas += 1
        @statistic.CantPregRespondidasMal += 1  # Corrige el nombre aquí
        session[:resultado] = "Respuesta incorrecta. La respuesta correcta es: #{@question.correct_answer}"
      end
      @statistic.save
      session[:mostrar_mensaje] = true
      redirect '/preguntas'
    else
      redirect '/'
    end
  end

  get '/lecciones' do 
    @lecciones = Lesson.all
    erb :lecciones
  end
  
  def calularNivelesParaUsuarios
    User.find_each do |user|
      user_statistics = user.statistics.last
      if user_statistics 
        correctas = user_statistics.cantPregRespondidasBien || 0
        incorrectas = user_statistics.CantPregRespondidasMal || 0

        puntos_totales = (correctas * 10) - (incorrectas * 4)
        puntos_totales = [0, puntos_totales].max

        user.update(total_points: puntos_totales)

        nuevo_nivel = calcularNivel(puntos_totales)
        user.levels.update(level_number: nuevo_nivel)
      end
    end
  end

  def calcularNivel(puntos)
    case puntos
    when 0..99
      1
    when 100..199
      2
    when 200..299
      3
    when 300..399
      4
    when 400..499
      5
    when 500..599
      6
    when 600..699
      7
    when 700..799
      8
    when 800..899
      9
    else
      10
    end
  end
end

App.run! if __FILE__ == $0
