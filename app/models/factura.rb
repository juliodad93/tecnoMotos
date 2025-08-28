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
  
  private
  
  def generar_numero_factura
    return if numero_factura.present?
    
    # Usar una transacción para evitar race conditions
    Factura.transaction do
      # Buscar el último número numérico más alto, no por orden alfabético
      ultimo_numero = Factura.where("numero_factura REGEXP ?", '^F[0-9]+$')
                            .pluck(:numero_factura)
                            .map { |num| num.gsub(/\D/, '').to_i }
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
    return unless detalles_facturas.loaded? || detalles_facturas.any?
    
    self.subtotal = detalles_facturas.sum { |detalle| detalle.cantidad * detalle.costo_item }
    self.impuestos ||= 0
    self.total = subtotal + impuestos
  end
  
  def calcular_totales!
    calcular_totales
    save!
  end
end
