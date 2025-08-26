class Pedido < ApplicationRecord
  self.table_name = 'pedidos'
  
  belongs_to :proveedor
  belongs_to :user
  has_many :detalles_pedidos, dependent: :destroy
  
  validates :nombre_pedido, presence: true
  validates :fecha_pedido, presence: true
  validates :estado, presence: true
  validates :total, presence: true, numericality: { greater_than: 0 }
end
