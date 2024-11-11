# frozen_string_literal: true

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
    @question = Question.new(description: params[:description], options: params[:options],
                             correct_answer: params[:correct_option])
    @question.save
    redirect '/trucoAdmin'
  end

  get '/preguntas' do
    @user = User.find(session[:user_id])
    @life = @user.lives.last
    @question = Question.order('RANDOM()').first
    @resultado = session.delete(:resultado)
    erb :preguntas, locals: { vida: @life }
  end

  post '/preguntas/responder' do
    if session[:user_id]
      @user = User.find(session[:user_id])
      @statistic = @user.statistics.last
      @life = @user.lives.last
      @level = @user.levels.last

      if @life.cantidadDeVidas.positive?
        procesar_respuesta(params[:pregunta_id], params[:respuesta])
        actualizar_nivel_usuario(@statistic.total_points)
        guardar_cambios
        session[:mostrar_mensaje] = true
      else
        session[:resultado] = 'No tienes más vidas'
      end
      redirect '/preguntas'
    else
      redirect '/'
    end
  end

  def procesar_respuesta(pregunta_id, respuesta)
    @question = Question.find(pregunta_id)
    if @question.correct_answer?(respuesta)
      actualizar_estadisticas_correcta
      session[:resultado] = '¡Respuesta correcta!'
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
    @level.update(level_number: nuevo_nivel)
  end

  def calcular_nivel(puntos)
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

  def guardar_cambios
    @statistic.save
    @life.save
    @question.save
  end
end
