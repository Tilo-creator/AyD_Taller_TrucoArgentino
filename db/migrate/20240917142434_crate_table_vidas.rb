# frozen_string_literal: true

# Migracion para crear la tabla de vidas en la base de datos
class CrateTableVidas < ActiveRecord::Migration[7.1]
  def change
    create_table :lives do |t|
      t.integer :cantidadDeVidas, default: 3
      t.references :user, foreign_key: true

      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
