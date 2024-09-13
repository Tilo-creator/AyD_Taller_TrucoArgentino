class TableLevels < ActiveRecord::Migration[7.1]
  def change
    create_table :levels do |t|
      t.integer :level_number
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
