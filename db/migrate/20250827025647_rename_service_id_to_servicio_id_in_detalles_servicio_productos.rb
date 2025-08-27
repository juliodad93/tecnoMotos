class RenameServiceIdToServicioIdInDetallesServicioProductos < ActiveRecord::Migration[8.0]
  def change
    # Eliminar foreign key existente
    remove_foreign_key :detalles_servicio_productos, :servicios if foreign_key_exists?(:detalles_servicio_productos, :servicios)
    
    # Renombrar columna
    rename_column :detalles_servicio_productos, :service_id, :servicio_id
    
    # Agregar foreign key con el nuevo nombre
    add_foreign_key :detalles_servicio_productos, :servicios, column: :servicio_id
  end
end
