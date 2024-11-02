# frozen_string_literal: true

# Migracion para crear la tabla de niveles en la base de datos
class CreateLevels < ActiveRecord::Migration[7.1]
  def change
    create_table :levels do |t|
      t.integer :level_number, default: 0 # Corrección aquí
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
