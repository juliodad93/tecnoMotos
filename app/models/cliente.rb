class Cliente < ApplicationRecord
  has_many :vehiculos, dependent: :destroy
  has_many :facturas, dependent: :destroy
  
  validates :nombre, :apellido, :identificacion, presence: true
  validates :identificacion, uniqueness: true
  validates :correo, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  
  def nombre_completo
    "#{nombre} #{apellido}"
  end
end
