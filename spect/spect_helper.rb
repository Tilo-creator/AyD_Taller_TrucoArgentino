ENV['RACK_ENV'] = 'test' # Configura el entorno de la aplicación en modo test

require './app'          # Carga la aplicación Sinatra (asegúrate de que el path es correcto)
require 'rspec'          # Carga la gema RSpec
require 'rack/test'      # Provee métodos útiles para probar aplicaciones Rack (Sinatra se basa en Rack)

RSpec.configure do |config|
  config.include Rack::Test::Methods  # Incluye los métodos de Rack::Test
end

def app
  App.new  # Devuelve la instancia de la aplicación Sinatra
end
