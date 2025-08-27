class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :pedidos, dependent: :destroy
  has_many :facturas, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  
  # Enum para los cargos
  enum :cargo, {
    administrador: 'administrador',
    tecnico: 'tecnico', 
    comercial: 'comercial',
    administrativo: 'administrativo'
  }
  
  validates :email_address, presence: true, uniqueness: true
  validates :nombre, :apellido, presence: true
  validates :cargo, presence: true, inclusion: { in: cargos.keys }

  # Métodos helper para los cargos
  def nombre_completo
    "#{nombre} #{apellido}"
  end

  def cargo_humanizado
    case cargo
    when 'administrador'
      'Administrador'
    when 'tecnico'
      'Técnico'
    when 'comercial'
      'Comercial'
    when 'administrativo'
      'Administrativo'
    else
      cargo.capitalize
    end
  end

  # Scopes útiles
  scope :administradores, -> { where(cargo: 'administrador') }
  scope :tecnicos, -> { where(cargo: 'tecnico') }
  scope :comerciales, -> { where(cargo: 'comercial') }
  scope :administrativos, -> { where(cargo: 'administrativo') }

  # Método de clase para obtener las opciones del select
  def self.cargo_options
    [
      ['Administrador', 'administrador'],
      ['Técnico', 'tecnico'],
      ['Comercial', 'comercial'],
      ['Administrativo', 'administrativo']
    ]
  end

  # Método de clase para obtener las opciones del select (sin administrador)
  def self.cargo_options_no_admin
    [
      ['Técnico', 'tecnico'],
      ['Comercial', 'comercial'],
      ['Administrativo', 'administrativo']
    ]
  end

  # Método para verificar si el usuario es administrador
  def admin?
    cargo == 'administrador'
  end
end
