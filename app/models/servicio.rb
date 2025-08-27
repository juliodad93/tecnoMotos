class Servicio < ApplicationRecord
  self.table_name = 'servicios'
  
  has_many :detalles_facturas, dependent: :destroy
  has_many :detalles_servicio_vehiculos, dependent: :destroy
  has_many :detalles_servicio_productos, class_name: 'DetalleServicioProducto', dependent: :destroy
  
  validates :nombre, presence: true
  validates :precio_base, presence: true, numericality: { greater_than: 0 }
  validates :categoria, presence: true
  
  scope :activos, -> { where(activo: true) }
  scope :por_categoria, ->(categoria) { where(categoria: categoria) }
  
  # Categorías disponibles
  CATEGORIAS = {
    'mantenimiento_preventivo' => 'Mantenimiento Preventivo',
    'mantenimiento_correctivo' => 'Mantenimiento Correctivo',
    'electricidad' => 'Electricidad',
    'motor' => 'Motor',
    'transmision' => 'Transmisión',
    'frenos' => 'Frenos',
    'suspension' => 'Suspensión',
    'carroceria' => 'Carrocería',
    'neumaticos' => 'Neumáticos',
    'diagnostico' => 'Diagnóstico',
    'otros' => 'Otros'
  }.freeze
  
  def categoria_humanizada
    CATEGORIAS[categoria] || categoria&.titleize || 'Sin categoría'
  end
  
  def duracion_en_horas
    return 0 unless duracion_estimada.present?
    (duracion_estimada / 60.0).round(2)
  end
  
  def precio_por_hora
    return 0 unless duracion_estimada.present? && duracion_estimada > 0
    (precio_base / duracion_en_horas).round(2)
  end
  
  def total_facturado
    detalles_facturas.sum(:subtotal) || 0
  end
  
  def veces_usado
    detalles_facturas.count
  end
end
