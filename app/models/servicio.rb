class Servicio < ApplicationRecord
  self.table_name = 'servicios'
  
  has_many :detalles_facturas, dependent: :destroy
  has_many :detalles_servicio_vehiculos, dependent: :destroy
  has_many :detalles_servicio_productos, dependent: :destroy
  
  validates :nombre, presence: true
  validates :precio_base, presence: true, numericality: { greater_than: 0 }
  validates :categoria, presence: true
  
  scope :activos, -> { where(activo: true) }
  scope :por_categoria, ->(categoria) { where(categoria: categoria) }
end
