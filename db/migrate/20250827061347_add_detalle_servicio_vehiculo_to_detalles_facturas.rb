class AddDetalleServicioVehiculoToDetallesFacturas < ActiveRecord::Migration[8.0]
  def change
    add_column :detalles_facturas, :detalle_servicio_vehiculo_id, :integer
    add_index :detalles_facturas, :detalle_servicio_vehiculo_id
    add_foreign_key :detalles_facturas, :detalles_servicio_vehiculos, column: :detalle_servicio_vehiculo_id
  end
end
