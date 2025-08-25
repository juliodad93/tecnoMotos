class CreateVehicles < ActiveRecord::Migration[8.0]
  def change
    create_table :vehicles do |t|
      t.string :matricula
      t.string :modelo
      t.string :marca
      t.integer :anio
      t.string :color
      t.text :descripcion
      t.references :client, null: false, foreign_key: true

      t.timestamps
    end
    add_index :vehicles, :matricula, unique: true
  end
end
