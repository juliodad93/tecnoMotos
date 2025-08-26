class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :nombre
      t.text :descripcion
      t.integer :cantidad_disponible
      t.decimal :precio_unitario
      t.decimal :precio_venta
      t.string :sku
      t.references :proveedor, null: false, foreign_key: { to_table: :proveedores }
      t.datetime :fecha_registro
      t.datetime :ultima_actualizacion

      t.timestamps
    end
    add_index :products, :sku, unique: true
  end
end
