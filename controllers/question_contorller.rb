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
    
    get '/generarPregunta' do
      erb :formulario
    end
  
    post '/generarPregunta' do
      @question = Question.new(description: params[:description], options: params[:options], correct_answer: params[:correct_option])
      @question.save
      redirect '/trucoAdming'
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
            @question.vecesRespondidasMal += 1
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
  end
  