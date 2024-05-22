class Question < ActiveRecord::Migration[7.1]
  def change
    create_table :question do |t|
      t.string :number
      t.string :description


      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
