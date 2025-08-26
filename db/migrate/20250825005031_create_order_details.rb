class CreateOrderDetails < ActiveRecord::Migration[8.0]
  def change
    create_table :order_details do |t|
      t.references :pedido, null: false, foreign_key: { to_table: :orders }
      t.references :producto, null: false, foreign_key: { to_table: :products }
      t.integer :cantidad
      t.decimal :precio_unitario

      t.timestamps
    end
  end
end
