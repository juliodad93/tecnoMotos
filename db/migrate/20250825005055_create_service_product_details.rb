class CreateServiceProductDetails < ActiveRecord::Migration[8.0]
  def change
    create_table :service_product_details do |t|
      t.references :service, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :cantidad_usada
      t.decimal :precio_unitario

      t.timestamps
    end
  end
end
