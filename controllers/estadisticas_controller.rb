# frozen_string_literal: true

# controlador para estadisticas
class EstadisticasController < Sinatra::Base
  get '/estadisticas/:id' do
    @user = User.find(params[:id])
    @statistic = @user.statistics.last
    erb :estadisticas, locals: { estadistic: @statistic }
  end
end
