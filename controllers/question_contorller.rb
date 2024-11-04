require './models/user'
require './models/lesson'
require './models/question'
require './models/statistic'
require './models/life'
require './models/application_record'
require './models/level'

class QuestionController < Sinatra::Base
  configure do
    set :views, './views'
  end
  
  # Rutas
  get '/generarPregunta' do
    erb :formulario
  end

  post '/generarPregunta' do
    @question = Question.new(description: params[:description], options: params[:options], correct_answer: params[:correct_option])
    @question.save
    redirect '/trucoAdmin'
  end

  get '/preguntas' do
    @user = User.find(session[:user_id])
    @life = @user.lives.last
    @question = Question.order("RANDOM()").first
    @resultado = session.delete(:resultado)
    erb :preguntas, locals: { vida: @life }
  end
  
  post '/preguntas/responder' do
    if session[:user_id]
      @user = User.find(session[:user_id])
      @statistic = @user.statistics.last
      @life = @user.lives.last

      if @life.cantidadDeVidas > 0
        procesar_respuesta(params[:pregunta_id], params[:respuesta])
        actualizar_nivel_usuario(@statistic.total_points)
        guardar_cambios
        session[:mostrar_mensaje] = true
        redirect '/preguntas'
      else
        session[:resultado] = "No tienes más vidas"
        redirect '/preguntas'
      end
    else
      redirect '/'
    end
  end
  
  # Métodos auxiliares

  def procesar_respuesta(pregunta_id, respuesta)
    @question = Question.find(pregunta_id)
    if @question.correct_answer?(respuesta)
      actualizar_estadisticas_correcta
      session[:resultado] = "¡Respuesta correcta!"
    else
      actualizar_estadisticas_incorrecta
      session[:resultado] = "Respuesta incorrecta. La respuesta correcta es: #{@question.correct_answer}"
    end
  end
  
  def actualizar_estadisticas_correcta
    @statistic.cantidadDePreguntaRespondidas += 1
    @question.vecesRespondidasBien += 1 
    @statistic.cantPregRespondidasBien += 1
    @statistic.total_points += 5
  end
  
  def actualizar_estadisticas_incorrecta
    @statistic.cantidadDePreguntaRespondidas += 1
    @statistic.cantPregRespondidasMal += 1
    @question.vecesRespondidasMal += 1
    @statistic.total_points -= 3
    @life.cantidadDeVidas -= 1
  end
  
  def actualizar_nivel_usuario(puntos)
    nuevo_nivel = calcular_nivel(puntos)
    if @user.level.level_number != nuevo_nivel
      @user.level.update(level_number: nuevo_nivel)
    end
  end

  def guardar_cambios
    @statistic.save
    @life.save
    @question.save
  end
end
