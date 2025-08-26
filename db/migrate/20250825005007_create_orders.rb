class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.string :nombre_pedido
      t.datetime :fecha_pedido
      t.string :estado
      t.decimal :total
      t.references :proveedor, null: false, foreign_key: { to_table: :proveedores }
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
