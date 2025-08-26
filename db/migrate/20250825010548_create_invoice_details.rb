class CreateInvoiceDetails < ActiveRecord::Migration[8.0]
  def change
    create_table :invoice_details do |t|
      t.references :factura, null: false, foreign_key: { to_table: :invoices }
      t.string :tipo_item
      t.integer :quantity
      t.decimal :cost_item
      t.text :description
      t.references :service, null: true, foreign_key: false # Será agregada después
      t.references :producto, null: false, foreign_key: { to_table: :products }

      t.timestamps
    end
  end
end
