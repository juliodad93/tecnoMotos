class CreateInvoiceDetails < ActiveRecord::Migration[8.0]
  def change
    create_table :invoice_details do |t|
      t.references :invoice, null: false, foreign_key: true
      t.string :tipo_item
      t.integer :quantity
      t.decimal :cost_item
      t.text :description
      t.references :service, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
