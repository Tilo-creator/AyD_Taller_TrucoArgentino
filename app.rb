require 'sinatra'
require 'sinatra/activerecord'
require './models/user'
require './models/lesson'
require './models/question'
require './models/statistic'
require './models/life'
require './models/application_record'

set :database_file, './config/database.yml'

class App < Sinatra::Application
  enable :sessions

  # Página de inicio que maneja tanto el inicio de sesión como el registro
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
      
      
      # Manejo del registro
      if params[:password] == params[:confirm_password]
        @user = User.new(names: params[:fullname], username: params[:username], email: params[:email], password: params[:password])
        if @user.save
          session[:user_id] = @user.id
          @statistic = Statistic.new(cantidadDePreguntaRespondidas: "0", cantPregRespondidasBien: "0", CantPregRespondidasMal:"0", user_id: @user.id)
          @statistic.save
          @life = Life.new(cantidadDeVidas: "3", user_id: @user.id)
          @life.save
          redirect '/juegos'
        else
          erb :inicio, locals: { mensaje: 'Hubo un error al registrar el usuario. Inténtalo de nuevo.' }
        end
      else
        erb :inicio, locals: { mensaje: 'Las contraseñas no coinciden.' }
      end
    else
      redirect '/'
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

  get '/lecciones' do
    @lecciones= Lesson.all
    erb:lecciones
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
    @user = User.find(session[:user_id])
    if @user.isAdmin
      redirect'/trucoAdming'
    end
    @lessons = Lesson.all
    @life = @user.lives.last
    erb :truco, locals: { lessons: @lessons, vida: @life }
  end

  get '/trucoAdming' do
    @user = User.find(session[:user_id])
    @lessons = Lesson.all
    @life = @user.lives.last
    erb :trucoAdming, locals: { lessons: @lessons, vida: @life }
  end

  get '/preguntas' do
    @user = User.find(session[:user_id])
    @life = @user.lives.last
    @question = Question.order("RANDOM()").first
    @resultado = session.delete(:resultado)
    erb :preguntas, locals: { vida: @life}
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
      @life = @user.lives.last
      # Inicializar los contadores si son nil
      @statistic.cantidadDePreguntaRespondidas ||= 0
      @statistic.cantPregRespondidasBien ||= 0
      @statistic.CantPregRespondidasMal ||= 0
      if @life.cantidadDeVidas > 0
        @question = Question.find(params[:pregunta_id])
        if @question.correct_answer?(params[:respuesta])
         @statistic.cantidadDePreguntaRespondidas += 1
         @statistic.cantPregRespondidasBien += 1
          session[:resultado] = "¡Respuesta correcta!"
        else
          @statistic.cantidadDePreguntaRespondidas += 1
          @statistic.CantPregRespondidasMal += 1
          @life.cantidadDeVidas -= 1
          session[:resultado] = "Respuesta incorrecta. La respuesta correcta es: #{@question.correct_answer}"
        end
        @statistic.save
        @life.save
        session[:mostrar_mensaje] = true
        redirect '/preguntas'
      else
        session[:resultado] = "No tienes mas vidas"
        redirect '/preguntas'
      @statistic.puntos ||= 0

      @question = Question.find(params[:pregunta_id])
      if @question.correct_answer?(params[:respuesta])
        @statistic.cantidadDePreguntaRespondidas += 1
        @statistic.cantPregRespondidasBien += 1
        @statistic.puntos += 10
        session[:resultado] = "¡Respuesta correcta!"
      else
        @statistic.cantidadDePreguntaRespondidas += 1
        @statistic.CantPregRespondidasMal += 1
        @statistic.puntos-=4
        session[:resultado] = "Respuesta incorrecta. La respuesta correcta es: #{@question.correct_answer}"
      end
    else
      redirect '/'
    end
  end

  get'/lecciones' do 
    @lecciones =Lesson.all
    erb:lecciones
  end
  




    def calularNivelesParaUsuarios
      User.find_each do |user|
        user_statistics = user.statistics.last # Arreglar typo
        if user_statistics
          correctas = user_statistics.cantPregRespondidasBien || 0
          incorrectas = user_statistics.CantPregRespondidasMal || 0
    
          puntos_totales = (correctas * 10) - (incorrectas * 4) # Multiplicación corregida
          puntos_totales = [0, puntos_totales].max # No dejar puntaje negativo
    
          user.update(total_points: puntos_totales)
    
          nuevo_nivel = calcularNivel(puntos_totales) # Usar el método correcto
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
