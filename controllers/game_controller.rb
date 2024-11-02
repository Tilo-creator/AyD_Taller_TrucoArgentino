require './models/user'
require './models/lesson'
require './models/question'
require './models/statistic'
require './models/life'
require './models/application_record'
require './models/level'
class GameController < Sinatra::Base
  configure do
    set :views, './views'
  end
  get '/juegos' do
    juegos = ['Truco', 'Poker', 'Escoba']
    erb :juegos, locals: { juegos: juegos }
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
end
