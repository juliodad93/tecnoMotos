class DetalleServicioVehiculo < ApplicationRecord
  self.table_name = 'detalles_servicio_vehiculos'
  
  belongs_to :servicio
  belongs_to :vehiculo
  has_many :detalles_facturas, class_name: 'DetalleFactura', dependent: :nullify
  
  validates :descripcion, presence: true
  # validates :fecha_inicio, presence: true # Permitir servicios sin iniciar
  
  # Scopes
  scope :no_iniciados, -> { where(fecha_inicio: nil) }
  scope :en_progreso, -> { where.not(fecha_inicio: nil).where(fecha_fin: nil) }
  scope :completados, -> { where.not(fecha_fin: nil) }
  scope :por_servicio, ->(servicio_id) { where(servicio_id: servicio_id) }
  scope :por_vehiculo, ->(vehiculo_id) { where(vehiculo_id: vehiculo_id) }
  
  # Métodos de instancia
  def no_iniciado?
    fecha_inicio.nil?
  end
  
  def en_progreso?
    fecha_inicio.present? && fecha_fin.nil?
  end
  
  def completado?
    fecha_fin.present?
  end
  
  def estado
    if no_iniciado?
      'No Iniciado'
    elsif en_progreso?
      'En Progreso' 
    else
      'Completado'
    end
  end
  
  def duracion_minutos
    return nil unless completado?
    ((fecha_fin - fecha_inicio) / 1.minute).round
  end
  
  def duracion_horas
    return nil unless completado?
    (duracion_minutos / 60.0).round(2)
  end
  
  def cliente
    vehiculo.cliente
  end
  
  # Métodos para facturación
  def facturado?
    detalles_facturas.any?
  end
  
  def facturas
    Factura.joins(:detalles_facturas).where(detalles_facturas: { detalle_servicio_vehiculo_id: id }).distinct
  end
  
  def puede_facturarse?
    completado? && !facturado?
  end
end
