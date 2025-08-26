class DetalleServicioProducto < ApplicationRecord
  self.table_name = 'detalles_servicio_productos'
  
  belongs_to :servicio
  belongs_to :producto
  
  validates :cantidad_usada, presence: true, numericality: { greater_than: 0 }
  validates :precio_unitario, presence: true, numericality: { greater_than: 0 }
end
