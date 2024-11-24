require './app'
require 'sinatra/activerecord'

set :database_file, './config/database.yml'

# Configurar el entorno a producción explícitamente
set :environment, :production

run App
