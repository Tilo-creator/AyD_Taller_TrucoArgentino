require 'sinatra'
require 'sinatra/activerecord'
require './models/user'
require './models/lesson'
require './models/question'
require './models/statistic'
require './models/life'
require './models/application_record'
require './models/level'


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

  # Ruta para ver estadísticas de preguntas
get '/estadisticasPreguntas' do
    @questions_most_correct = Question.order(vecesRespondidasBien: :desc).limit(5)

    @questions_most_incorrect = Question.order(vecesRespondidasMal: :desc).limit(5)
  
    erb :estadisticasPreguntas
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
      # Crear un nivel inicial para el usuario con level_number en 0
      @user.create_level(level_number: 0)

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

  get '/generarPregunta' do
    erb:formulario
  end
  
  post '/generarPregunta' do
    @question = Question.new(description: params[:description], options: params[:options], correct_answer: params[:correct_option])
    @question.save
    redirect '/trucoAdming'
  end
  
  get '/lecciones' do 
    @lecciones = Lesson.all
    erb :lecciones
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
      
      if @life.cantidadDeVidas > 0
        @question = Question.find(params[:pregunta_id])
  
        if @question.correct_answer?(params[:respuesta])
          @statistic.cantidadDePreguntaRespondidas += 1
          @question.vecesRespondidasBien += 1 
          @statistic.cantPregRespondidasBien += 1
          @statistic.total_points += 5
          session[:resultado] = "¡Respuesta correcta!"
        else
          @statistic.cantidadDePreguntaRespondidas += 1
          @statistic.cantPregRespondidasMal += 1
          @question.vecesRespondidasMal +=1
          @statistic.total_points -= 3
          @life.cantidadDeVidas -= 1
          session[:resultado] = "Respuesta incorrecta. La respuesta correcta es: #{@question.correct_answer}"
        end
  
        # Guardar cambios en la estadística y vidas
        @statistic.save
        @life.save
        @question.save
  
        # Mostrar mensaje y redirigir a la página de preguntas
        session[:mostrar_mensaje] = true
        redirect '/preguntas'
      else
        # Si no hay más vidas, mostrar el mensaje correspondiente
        session[:resultado] = "No tienes más vidas"
        redirect '/preguntas'
      end
    else
      # Si no hay sesión activa, redirigir a la página principal
      redirect '/'
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