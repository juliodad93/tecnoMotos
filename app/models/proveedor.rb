class Proveedor < ApplicationRecord
  self.table_name = 'proveedores'
  
  has_many :productos, dependent: :destroy
  has_many :pedidos, dependent: :destroy
  
  validates :nombre, presence: true
  validates :identificacion, presence: true, uniqueness: true
  validates :telefono, presence: true
  validates :correo, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
