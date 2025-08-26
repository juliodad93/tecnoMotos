class CreateServiceProductDetails < ActiveRecord::Migration[8.0]
  def change
    create_table :service_product_details do |t|
      t.references :service, null: true, foreign_key: false # Será agregada después
      t.references :producto, null: false, foreign_key: { to_table: :products }
      t.integer :cantidad_usada
      t.decimal :precio_unitario

      t.timestamps
    end
  end
end
