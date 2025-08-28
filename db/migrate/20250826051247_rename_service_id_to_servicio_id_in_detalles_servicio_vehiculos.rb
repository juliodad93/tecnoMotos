class RenameServiceIdToServicioIdInDetallesServicioVehiculos < ActiveRecord::Migration[8.0]
  def change
    rename_column :detalles_servicio_vehiculos, :service_id, :servicio_id
    
    # También agregar la foreign key si no existe
    unless foreign_key_exists?(:detalles_servicio_vehiculos, :servicios)
      add_foreign_key :detalles_servicio_vehiculos, :servicios, column: :servicio_id
    end
  end
end
