class AddFechasEstadoToFacturas < ActiveRecord::Migration[8.0]
  def change
    add_column :facturas, :fecha_pago, :date
    add_column :facturas, :fecha_anulacion, :date
  end
end
