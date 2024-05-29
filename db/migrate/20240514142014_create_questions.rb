class CreateQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :questions do |t|
      t.text :content
      t.references :lesson, foreign_key: true  # Relación con las lecciones
      t.timestamps
    end
  end
end