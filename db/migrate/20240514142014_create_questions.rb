class CreateQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :questions do |t|
      t.text :description, null: false
      t.string :options, null: false
      t.string :correct_answer, null: false
      t.integer :vecesRespondidasBien, default: 0
      t.integer :vecesRespondidasMal , default: 0 


      t.timestamps
    end
  end
end
