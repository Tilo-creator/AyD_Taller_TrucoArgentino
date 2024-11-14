# frozen_string_literal: true

require './models/user'
require './models/lesson'
require './models/question'
require './models/statistic'
require './models/life'
require './models/application_record'
require './models/level'
# controlador para estadisticas
class EstadisticasController < Sinatra::Base
  configure do
    set :views, './views'
  end

  get '/estadisticas' do
    @user = User.find(session[:user_id])
    @statistic = @user.statistics.last
    erb :estadisticas, locals: { estadistic: @statistic }
  end
end
