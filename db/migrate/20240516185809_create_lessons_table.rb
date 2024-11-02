# frozen_string_literal: true

# Migracion para crear la tabla de lecciones en la base de datos
class CreateLessonsTable < ActiveRecord::Migration[7.1]
  def change
    create_table :lessons do |t|
      t.string :chapter
      t.string :title
      t.string :description
      t.references :question, foreign_key: true

      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
