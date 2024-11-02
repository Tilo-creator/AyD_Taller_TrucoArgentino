# frozen_string_literal: true

# Migracion para agregar una columna a la tabla usuario
class AddUserTypeToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :isAdmin, :boolean, default: false
  end
end
