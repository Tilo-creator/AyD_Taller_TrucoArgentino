# frozen_string_literal: true

require 'sinatra/activerecord/rake'
require './app'
require 'rake'
require 'yaml'
require 'psych'

Psych.safe_load(File.read('config/database.yml'), aliases: true)

# Cargar configuraciones desde database.yml
db_config = YAML.load_file('config/database.yml')

# Establecer conexión
ActiveRecord::Base.establish_connection(db_config[ENV['RAILS_ENV'] || 'production'])

# Incluir tareas de rake
Dir.glob('lib/tasks/**/*.rake').each { |r| load r }

namespace :db do
  desc 'Crea una migración'
  task :create_migration, [:name] => :environment do |_, args|
    name = args[:name]
    version = Time.now.utc.strftime('%Y%m%d%H%M%S')
    migration_name = "#{version}_#{name}.rb"
    migration_file = File.join('db', 'migrate', migration_name)

    File.open(migration_file, 'w') do |file|
      file.write("class #{name.camelize} < ActiveRecord::Migration[7.1]\n")
      file.write("  def change\n")
      file.write("    # Agrega aquí el código de tu migración\n")
      file.write("  end\n")
      file.write("end\n")
    end

    puts "Migración creada en #{migration_file}"
  end
end
