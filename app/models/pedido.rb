class Pedido < ApplicationRecord
  self.table_name = 'pedidos'
  
  belongs_to :proveedor
  belongs_to :user
  has_many :detalles_pedidos, class_name: 'DetallePedido', dependent: :destroy
  accepts_nested_attributes_for :detalles_pedidos, allow_destroy: true, reject_if: :all_blank
  
  validates :nombre_pedido, presence: true
  validates :fecha_pedido, presence: true
  validates :estado, presence: true
  validates :total, presence: true, numericality: { greater_than: 0 }
  
  # Estados disponibles
  ESTADOS = {
    'pendiente' => 'Pendiente',
    'enviado' => 'Enviado',
    'recibido' => 'Recibido',
    'completado' => 'Completado',
    'cancelado' => 'Cancelado'
  }.freeze
  
  scope :pendientes, -> { where(estado: 'pendiente') }
  scope :enviados, -> { where(estado: 'enviado') }
  scope :recibidos, -> { where(estado: 'recibido') }
  scope :completados, -> { where(estado: 'completado') }
  scope :del_proveedor, ->(proveedor_id) { where(proveedor_id: proveedor_id) }
  scope :del_mes, ->(fecha = Date.current) { where(fecha_pedido: fecha.beginning_of_month..fecha.end_of_month) }
  
  before_validation :generar_nombre_pedido, if: :new_record?
  before_save :calcular_total
  
  def estado_humanizado
    ESTADOS[estado] || estado&.titleize || 'Sin estado'
  end
  
  def esta_pendiente?
    estado == 'pendiente'
  end
  
  def esta_completado?
    estado == 'completado'
  end
  
  def esta_cancelado?
    estado == 'cancelado'
  end
  
  def puede_editarse?
    %w[pendiente enviado].include?(estado)
  end
  
  def puede_cancelarse?
    %w[pendiente enviado].include?(estado)
  end
  
  def proveedor_nombre
    proveedor.nombre
  end
  
  def usuario_responsable
    "#{user.nombre} #{user.apellido}"
  end
  
  def dias_desde_pedido
    return 0 unless fecha_pedido.present?
    (Date.current - fecha_pedido.to_date).to_i
  end
  
  def total_productos
    detalles_pedidos.sum(:cantidad)
  end
  
  private
  
  def generar_nombre_pedido
    return if nombre_pedido.present?
    
    fecha_str = (fecha_pedido || Date.current).strftime("%Y%m%d")
    ultimo_pedido = Pedido.where("nombre_pedido LIKE ?", "PED-#{fecha_str}-%").order(:nombre_pedido).last
    
    if ultimo_pedido&.nombre_pedido.present?
      ultimo_numero = ultimo_pedido.nombre_pedido.split('-').last.to_i
      self.nombre_pedido = "PED-#{fecha_str}-#{(ultimo_numero + 1).to_s.rjust(3, '0')}"
    else
      self.nombre_pedido = "PED-#{fecha_str}-001"
    end
  end
  
  def calcular_total
    return unless detalles_pedidos.loaded? || detalles_pedidos.any?
    
    self.total = detalles_pedidos.sum { |detalle| detalle.cantidad * detalle.precio_unitario }
  end
end
