class CreateVehiculos < ActiveRecord::Migration[8.0]
  def change
    create_table :vehiculos do |t|
      t.string :matricula
      t.string :modelo
      t.string :marca
      t.integer :anio
      t.string :color
      t.text :descripcion
      t.references :cliente, null: false, foreign_key: true

      t.timestamps
    end
    add_index :vehiculos, :matricula, unique: true
  end
end
