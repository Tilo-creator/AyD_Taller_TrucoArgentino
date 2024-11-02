require './models/user'
require './models/lesson'
require './models/question'
require './models/statistic'
require './models/life'
require './models/application_record'
require './models/level'
# controlador para estadisticas
class EstadisticasController < Sinatra::Base
  get '/estadisticas/:id' do
    @user = User.find(params[:id])
    @statistic = @user.statistics.last
    erb :estadisticas, locals: { estadistic: @statistic }
  end
end
