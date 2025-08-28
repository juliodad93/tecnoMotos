class Factura < ApplicationRecord
  self.table_name = 'facturas'
  
  belongs_to :cliente
  belongs_to :user
  has_many :detalles_facturas, class_name: 'DetalleFactura', dependent: :destroy
  
  validates :numero_factura, presence: true, uniqueness: true
  validates :fecha_factura, presence: true
  validates :subtotal, presence: true, numericality: { greater_than: 0 }
  validates :total, presence: true, numericality: { greater_than: 0 }
  validates :metodo_pago, presence: true
  validates :estado, presence: true
  
  # Estados disponibles
  ESTADOS = {
    'pendiente' => 'Pendiente',
    'pagada' => 'Pagada',
    'anulada' => 'Anulada',
    'vencida' => 'Vencida'
  }.freeze
  
  # Métodos de pago disponibles
  METODOS_PAGO = {
    'efectivo' => 'Efectivo',
    'tarjeta_credito' => 'Tarjeta de Crédito',
    'tarjeta_debito' => 'Tarjeta de Débito',
    'transferencia' => 'Transferencia Bancaria',
    'cheque' => 'Cheque'
  }.freeze
  
  scope :pendientes, -> { where(estado: 'pendiente') }
  scope :pagadas, -> { where(estado: 'pagada') }
  scope :del_mes, ->(fecha = Date.current) { where(fecha_factura: fecha.beginning_of_month..fecha.end_of_month) }
  scope :del_cliente, ->(cliente_id) { where(cliente_id: cliente_id) }
  
  before_validation :generar_numero_factura, if: :new_record?
  before_save :calcular_totales
  
  def estado_humanizado
    ESTADOS[estado] || estado&.titleize || 'Sin estado'
  end
  
  def metodo_pago_humanizado
    METODOS_PAGO[metodo_pago] || metodo_pago&.titleize || 'Sin método'
  end
  
  def esta_pagada?
    estado == 'pagada'
  end
  
  def esta_pendiente?
    estado == 'pendiente'
  end
  
  def esta_vencida?
    estado == 'vencida'
  end
  
  def pendiente?
    estado == 'pendiente'
  end
  
  def pagada?
    estado == 'pagada'
  end
  
  def anulada?
    estado == 'anulada'
  end
  
  def dias_vencimiento
    return 0 unless fecha_factura.present?
    (Date.current - fecha_factura.to_date).to_i
  end
  
  def cliente_nombre_completo
    "#{cliente.nombre} #{cliente.apellido}"
  end
  
  def usuario_responsable
    "#{user.nombre} #{user.apellido}"
  end
  
  def calcular_totales!
    calcular_totales
    save!
  end
  
  private
  
  def generar_numero_factura
    return if numero_factura.present?
    
    # Usar una transacción para evitar race conditions
    Factura.transaction do
      # Buscar todos los números de factura que empiecen con 'F' y extraer números
      ultimo_numero = Factura.where("numero_factura LIKE ?", 'F%')
                            .pluck(:numero_factura)
                            .filter_map { |num| 
                              match = num.match(/^F(\d+)$/)
                              match ? match[1].to_i : nil
                            }
                            .max || 0
      
      # Generar el siguiente número
      proximo_numero = ultimo_numero + 1
      nuevo_numero = "F#{proximo_numero.to_s.rjust(6, '0')}"
      
      # Verificar que no existe (por si acaso)
      while Factura.exists?(numero_factura: nuevo_numero)
        proximo_numero += 1
        nuevo_numero = "F#{proximo_numero.to_s.rjust(6, '0')}"
      end
      
      self.numero_factura = nuevo_numero
    end
  end
  
  def calcular_totales
    # Obtener todos los detalles (incluyendo los que están en memoria con build)
    detalles = detalles_facturas.loaded? ? detalles_facturas.to_a : detalles_facturas
    
    return if detalles.empty?
    
    self.subtotal = detalles.sum { |detalle| (detalle.cantidad || 0) * (detalle.costo_item || 0) }
    self.impuestos ||= 0
    self.total = subtotal + impuestos
  end
  
end
