class AgregarForeignKeysServicios < ActiveRecord::Migration[8.0]
  def change
    # Agregar foreign keys para servicios después de que las tablas estén renombradas
    
    # Para detalles_facturas (si ya está renombrada) o invoice_details (si no)
    table_name = table_exists?(:detalles_facturas) ? :detalles_facturas : :invoice_details
    add_foreign_key table_name, :servicios, column: :servicio_id if table_exists?(:servicios)
    
    # Para detalles_servicio_vehiculos (si ya está renombrada) o service_vehicle_details (si no)
    table_name = table_exists?(:detalles_servicio_vehiculos) ? :detalles_servicio_vehiculos : :service_vehicle_details
    add_foreign_key table_name, :servicios, column: :servicio_id if table_exists?(:servicios)
    
    # Para detalles_servicio_productos (si ya está renombrada) o service_product_details (si no)
    table_name = table_exists?(:detalles_servicio_productos) ? :detalles_servicio_productos : :service_product_details
    add_foreign_key table_name, :servicios, column: :servicio_id if table_exists?(:servicios)
  end
end
