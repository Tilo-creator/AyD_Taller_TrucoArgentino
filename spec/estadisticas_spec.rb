require_relative 'spec_helper'
require 'rack/test'
require_relative '../app'

RSpec.describe "Estadísticas", type: :request do
  include Rack::Test::Methods

  def app
    App.new
  end

  before(:each) do
    User.delete_all
    Statistic.delete_all

    @user = User.create(names: "Test User", username: "testuser", email: "test@example.com", password: "password")
    @statistic = Statistic.create(
      cantidadDePreguntaRespondidas: 10,
      cantPregRespondidasBien: 7,
      CantPregRespondidasMal: 3,
      user_id: @user.id
    )
    post '/login', username: @user.username, password: @user.password
  end

  it "muestra las estadísticas para un usuario autenticado" do
    get '/estadisticas'

    expect(last_response).to be_ok
    expect(last_response.body).to include("Estadísticas")
    expect(last_response.body).to include("10")  # Verificar que el total de preguntas respondidas se muestra
    expect(last_response.body).to include("7")   # Verificar que las respuestas correctas se muestran
    expect(last_response.body).to include("3")   # Verificar que las respuestas incorrectas se muestran
  end

  it "redirige al login si no hay un usuario autenticado" do
    get '/logout' # Simula un logout para invalidar la sesión
    get '/estadisticas'

    expect(last_response).to be_redirect
    follow_redirect!
    expect(last_request.path).to eq('/login')
  end
end
