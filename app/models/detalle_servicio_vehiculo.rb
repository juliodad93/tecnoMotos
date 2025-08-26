class DetalleServicioVehiculo < ApplicationRecord
  self.table_name = 'detalles_servicio_vehiculos'
  
  belongs_to :servicio
  belongs_to :vehiculo
  
  validates :descripcion, presence: true
  validates :fecha_inicio, presence: true
end
