class DetallePedido < ApplicationRecord
  self.table_name = 'detalles_pedidos'
  
  belongs_to :pedido
  belongs_to :producto
  
  validates :cantidad, presence: true, numericality: { greater_than: 0 }
  validates :precio_unitario, presence: true, numericality: { greater_than: 0 }
end
