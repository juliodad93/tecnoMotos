class Factura < ApplicationRecord
  self.table_name = 'facturas'
  
  belongs_to :cliente
  belongs_to :user
  has_many :detalles_facturas, dependent: :destroy
  
  validates :numero_factura, presence: true, uniqueness: true
  validates :fecha_factura, presence: true
  validates :subtotal, presence: true, numericality: { greater_than: 0 }
  validates :total, presence: true, numericality: { greater_than: 0 }
  validates :metodo_pago, presence: true
  validates :estado, presence: true
end
