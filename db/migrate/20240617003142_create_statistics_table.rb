class CreateStatisticsTable < ActiveRecord::Migration[7.1]
  def change
    create_table :statistics do |t|
      t.integer :cantidadDePreguntaRespondidas, default: 0
      t.integer :cantPregRespondidasBien, default: 0
      t.integer :CantPregRespondidasMal, default: 0
      t.integer :total_point, default: 0

      t.references :user, foreign_key: true

      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
