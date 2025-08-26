class DetalleFactura < ApplicationRecord
  self.table_name = 'detalles_facturas'
  
  belongs_to :factura
  belongs_to :producto
  belongs_to :servicio
  
  validates :tipo_item, presence: true
  validates :cantidad, presence: true, numericality: { greater_than: 0 }
  validates :costo_item, presence: true, numericality: { greater_than: 0 }
end
