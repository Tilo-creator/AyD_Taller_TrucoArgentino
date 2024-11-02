require './models/lesson'
class LessonController < Sinatra::Base
    configure do
        set :views, './views'
    end
    get '/lecciones' do
      @lecciones = Lesson.all
      erb :lecciones
    end
  end
  