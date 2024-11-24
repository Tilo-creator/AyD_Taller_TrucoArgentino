# frozen_string_literal: true

require 'sinatra'
require 'sinatra/activerecord'
require './models/user'
require './models/lesson'
require './models/question'
require './models/statistic'
require './models/life'
require './models/application_record'
require './models/level'
require_relative './controllers/estadisticas_controller'
require_relative './controllers/game_controller'
require_relative './controllers/question_contorller'
require_relative './controllers/user_controller'
require_relative './controllers/lession_controller'
require 'yaml'
require 'sqlite3'

ENV['RACK_ENV'] = 'production'

set :database_file, './config/database.yml'

configure :production do
  db = YAML::load_file(database_file)
  ActiveRecord::Base.establish_connection(db['production'])
end

set :public_folder, 'public'
# Clase encargada de manejar la lógica principal de la aplicación
class App < Sinatra::Application
  use EstadisticasController
  use GameController
  use LessonController
  use QuestionController
  use UserController
  enable :sessions

  configure do
    set :views, './views'
  end

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
      redirect '/login' # Redirige a la página de registro
    end
  end

  # Ruta para ver estadísticas de preguntas
  get '/estadisticasPreguntas' do
    @questions_most_correct = Question.order(vecesRespondidasBien: :desc).limit(5)

    @questions_most_incorrect = Question.order(vecesRespondidasMal: :desc).limit(5)

    erb :estadisticasPreguntas
  end

  get '/lecciones' do
    @lecciones = Lesson.all
    erb :lecciones
  end

  get '/juegos/poker' do
    erb :poker
  end

  get '/juegos/escoba' do
    erb :escoba
  end

  get '/trucoAdming' do
    @user = User.find(session[:user_id])
    @lessons = Lesson.all
    @life = @user.lives.last
    erb :trucoAdming, locals: { lessons: @lessons, vida: @life }
  end
end

App.run! if __FILE__ == $PROGRAM_NAME
