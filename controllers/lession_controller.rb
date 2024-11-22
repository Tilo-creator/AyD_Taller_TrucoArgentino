# frozen_string_literal: true

require './models/lesson'
# controlador de vistas de lecciones
class LessonController < Sinatra::Base
  configure do
    set :views, './views'
  end
  get '/lecciones' do
    @lecciones = Lesson.all
    erb :lecciones
  end
end
