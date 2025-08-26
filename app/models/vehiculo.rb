class Vehiculo < ApplicationRecord
  self.table_name = 'vehiculos'
  
  belongs_to :cliente
  has_many :detalles_servicio_vehiculos, class_name: 'DetalleServicioVehiculo', dependent: :destroy
  
  validates :matricula, presence: true, uniqueness: true
  validates :modelo, presence: true
  validates :marca, presence: true
  validates :anio, presence: true
end
