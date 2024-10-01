class CreateStatisticsTable < ActiveRecord::Migration[7.1]
  def change
    create_table :statistics do |t|
      t.references :user, foreign_key: true
      t.integer :cantidadDePreguntaRespondidas, default: 0
      t.integer :cantPregRespondidasBien, default: 0
      t.integer :cantPregRespondidasMal, default: 0
      t.integer :total_points, default: 0 # Asegúrate de que esto esté aquí
      
      t.timestamps
    end
  end
end
