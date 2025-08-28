class CorregirProductoIdOpcionalEnDetallesFacturas < ActiveRecord::Migration[8.0]
  def change
    # Hacer producto_id opcional en detalles_facturas
    change_column_null :detalles_facturas, :producto_id, true
  end
end
