class CreateInvoices < ActiveRecord::Migration[8.0]
  def change
    create_table :invoices do |t|
      t.string :numero_factura
      t.datetime :fecha_factura
      t.decimal :subtotal
      t.decimal :impuestos
      t.decimal :total
      t.string :metodo_pago
      t.string :estado
      t.references :client, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :invoices, :numero_factura, unique: true
  end
end
