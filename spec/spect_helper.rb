ENV['RACK_ENV'] = 'test' # Configura el entorno de la aplicación en modo test

require './app'          # Carga la aplicación Sinatra (asegúrate de que el path es correcto)
require 'rspec'          # Carga la gema RSpec
require 'rack/test' 
require 'spec_helper'     # Provee métodos útiles para probar aplicaciones Rack (Sinatra se basa en Rack)

require 'simplecov'
SimpleCov.start

RSpec.configure do |config|
  config.include Rack::Test::Methods  # Incluye los métodos de Rack::Test
end

SimpleCov.start do
  add_filter '/spec/'
  add_filter '/config/'
end


def app
  App.new  # Devuelve la instancia de la aplicación Sinatra
end
