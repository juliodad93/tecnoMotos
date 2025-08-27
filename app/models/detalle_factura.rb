class DetalleFactura < ApplicationRecord
  self.table_name = 'detalles_facturas'
  
  belongs_to :factura
  belongs_to :producto, optional: true
  belongs_to :servicio, optional: true
  belongs_to :detalle_servicio_vehiculo, class_name: 'DetalleServicioVehiculo', optional: true
  
  validates :tipo_item, presence: true
  validates :cantidad, presence: true, numericality: { greater_than: 0 }
  validates :costo_item, presence: true, numericality: { greater_than: 0 }
  validates :descripcion, presence: true
  
  # Debe tener producto, servicio o detalle_servicio_vehiculo, pero no múltiples
  validate :debe_tener_una_fuente_exclusiva
  
  # Callback para establecer cantidad = 1 si es servicio
  before_validation :establecer_cantidad_servicio
  
  # Método para calcular subtotal
  def subtotal
    cantidad * costo_item
  end
  
  # Alias para precio_unitario (usado en vistas)
  def precio_unitario
    costo_item
  end
  
  # Verificar si es un producto
  def producto?
    producto_id.present?
  end
  
  # Verificar si es un servicio
  def servicio?
    servicio_id.present?
  end
  
  # Verificar si es un detalle de servicio de vehículo
  def detalle_servicio_vehiculo?
    detalle_servicio_vehiculo_id.present?
  end
  
  private
  
  def debe_tener_una_fuente_exclusiva
    fuentes = [producto_id, servicio_id, detalle_servicio_vehiculo_id].compact
    
    if fuentes.empty?
      errors.add(:base, 'Debe especificar un producto, servicio o detalle de servicio de vehículo')
    elsif fuentes.size > 1
      errors.add(:base, 'Solo puede tener una fuente: producto, servicio o detalle de servicio de vehículo')
    end
  end
  
  def establecer_cantidad_servicio
    if servicio_id.present?
      self.cantidad = 1
      self.tipo_item = 'servicio'
    elsif producto_id.present?
      self.tipo_item = 'producto'
    elsif detalle_servicio_vehiculo_id.present?
      self.cantidad = 1
      self.tipo_item = 'servicio_vehiculo'
    end
  end
end
