class CreateLessonsTable < ActiveRecord::Migration[7.1]
  def change
    create_table :lessons do |t|
      t.string :chapter
      t.string :title
      t.string :description
      t.references :user, null: false, foreign_key: true # Agrega la referencia a la tabla users

      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
