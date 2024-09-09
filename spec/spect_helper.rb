ENV['RACK_ENV'] = 'test'

require 'rack/test'
require 'rspec'
require 'simplecov'
SimpleCov.start

RSpec.configure do |config|
  config.include Rack::Test::Methods
end

def app
  App.new  # Aquí asegúrate de devolver la instancia correcta de tu aplicación
end
