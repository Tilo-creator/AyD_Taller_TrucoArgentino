class Progress < ActiveRecord::Migration[7.1]
  def change
    create_table :progres do |t|
      t.string :progressLessons
      t.string :progressQuestion
      

      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end