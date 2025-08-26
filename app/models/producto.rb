class Producto < ApplicationRecord
  self.table_name = 'productos'
  
  belongs_to :proveedor
  has_many :detalles_pedidos, dependent: :destroy
  has_many :detalles_facturas, dependent: :destroy
  has_many :detalles_servicio_productos, dependent: :destroy
  
  validates :nombre, presence: true
  validates :sku, presence: true, uniqueness: true
  validates :precio_unitario, presence: true, numericality: { greater_than: 0 }
  validates :precio_venta, presence: true, numericality: { greater_than: 0 }
  validates :cantidad_disponible, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
