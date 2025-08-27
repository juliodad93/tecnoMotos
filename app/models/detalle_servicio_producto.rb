class DetalleServicioProducto < ApplicationRecord
  self.table_name = 'detalles_servicio_productos'
  
  belongs_to :servicio
  belongs_to :producto
  
  validates :cantidad_usada, presence: true, numericality: { greater_than: 0 }
  validates :precio_unitario, presence: true, numericality: { greater_than: 0 }
  
  before_validation :set_precio_from_producto, if: :new_record?
  
  def total
    cantidad_usada * precio_unitario
  end
  
  private
  
  def set_precio_from_producto
    self.precio_unitario = producto.precio_venta if producto && precio_unitario.blank?
  end
end
