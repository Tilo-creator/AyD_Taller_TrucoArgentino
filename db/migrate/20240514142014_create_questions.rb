class CreateQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :questions do |t|
      t.text :description, null: false
      t.string :options, null: false
      t.string :correct_answer, null: false

      t.timestamps
    end
  end
end
