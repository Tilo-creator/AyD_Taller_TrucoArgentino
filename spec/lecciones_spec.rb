# frozen_string_literal: true

# spec/app_spec.rb
require 'spec_helper'
require 'rack/test'
require_relative '../app' # Asegúrate de que el archivo `app.rb` contenga tu aplicación Sinatra

RSpec.describe 'Lecciones', type: :request do
  include Rack::Test::Methods

  def app
    App.new
  end
  require 'spec_helper'
  require 'rack/test'
  require_relative '../app'

  before do
    # Crea algunas lecciones de prueba en la base de datos
    Lesson.create(title: 'Lección 1', description: 'Descripción de la lección 1', chapter: '1')
    Lesson.create(title: 'Lección 2', description: 'Descripción de la lección 2', chapter: '2')
  end

  after do
    # Limpia la base de datos después de cada prueba
    Lesson.delete_all
  end

  it 'muestra todas las lecciones' do
    get '/lecciones'
    expect(last_response).to be_ok
    expect(last_response.body).to include('Lección 1')
    expect(last_response.body).to include('Lección 2')
  end
end
