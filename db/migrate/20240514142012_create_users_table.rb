# frozen_string_literal: true

# Migracion para crear la tabla de usuarios en la base de datos
class CreateUsersTable < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :names
      t.string :username
      t.string :email
      t.string :password

      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
