class RenameServiceIdToServicioIdInDetallesFacturas < ActiveRecord::Migration[8.0]
  def change
    # Eliminar foreign key existente
    remove_foreign_key :detalles_facturas, :servicios if foreign_key_exists?(:detalles_facturas, :servicios)
    
    # Renombrar columna
    rename_column :detalles_facturas, :service_id, :servicio_id
    
    # Agregar foreign key con el nuevo nombre
    add_foreign_key :detalles_facturas, :servicios, column: :servicio_id
  end
end
