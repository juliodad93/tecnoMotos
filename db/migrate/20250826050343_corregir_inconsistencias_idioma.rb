class CorregirInconsistenciasIdioma < ActiveRecord::Migration[8.0]
  def change
    # Verificar si las tablas existen antes de renombrarlas
    
    # Renombrar tablas de inglés a español (solo si existen)
    rename_table :suppliers, :proveedores if table_exists?(:suppliers)
    rename_table :products, :productos if table_exists?(:products)
    rename_table :orders, :pedidos if table_exists?(:orders)
    rename_table :order_details, :detalles_pedidos if table_exists?(:order_details)
    rename_table :invoices, :facturas if table_exists?(:invoices)
    rename_table :invoice_details, :detalles_facturas if table_exists?(:invoice_details)
    rename_table :service_vehicle_details, :detalles_servicio_vehiculos if table_exists?(:service_vehicle_details)
    rename_table :service_product_details, :detalles_servicio_productos if table_exists?(:service_product_details)

    # Corregir nombres de columnas en detalles_facturas (si la tabla existe)
    if table_exists?(:detalles_facturas)
      rename_column :detalles_facturas, :quantity, :cantidad if column_exists?(:detalles_facturas, :quantity)
      rename_column :detalles_facturas, :cost_item, :costo_item if column_exists?(:detalles_facturas, :cost_item)
      rename_column :detalles_facturas, :description, :descripcion if column_exists?(:detalles_facturas, :description)
    end

    # Las referencias ya están configuradas correctamente en las migraciones
  end
end
