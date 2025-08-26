class CreateServicios < ActiveRecord::Migration[8.0]
  def change
    create_table :servicios do |t|
      t.string :nombre, null: false
      t.text :descripcion
      t.decimal :precio_base, precision: 10, scale: 2
      t.integer :duracion_estimada # en minutos
      t.string :categoria
      t.boolean :activo, default: true
      t.datetime :fecha_registro
      
      t.timestamps
    end
    
    add_index :servicios, :categoria
    add_index :servicios, :activo
  end
end
