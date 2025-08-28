module Authorization
  extend ActiveSupport::Concern

  included do
    before_action :check_authorization
  end

  private

  def check_authorization
    return if current_user&.admin? or current_user&.cargo == 'administrativo' # Los administradores pueden hacer todo
    
    controller = params[:controller]
    action = params[:action]
    
    case current_user&.cargo
    when 'tecnico'
      authorize_tecnico(controller, action)
    when 'comercial'
      authorize_comercial(controller, action)
    else
      redirect_to root_path, alert: 'No tienes permisos para acceder a esta sección.'
    end
  end

  def authorize_tecnico(controller, action)
    allowed_actions = {
      # Servicios - Solo ver pendientes y cerrar
      'detalles_servicio_vehiculos' => ['index', 'show', 'edit', 'update'],
      'detalles_servicio_productos' => ['index', 'show', 'edit', 'update'],
      
      # Solo lectura para contexto
      'clientes' => ['index', 'show'],
      'vehiculos' => ['index', 'show'],
      'productos' => ['index', 'show'],
      
      # Páginas básicas
      'sessions' => ['destroy'],
      'passwords' => ['edit', 'update']
    }

    unless allowed_actions[controller]&.include?(action)
      redirect_to root_path, alert: 'No tienes permisos para realizar esta acción.'
    end
  end

  def authorize_comercial(controller, action)
    allowed_actions = {
      # Servicios - Solo ver pendientes y cerrar
      'detalles_servicio_vehiculos' => ['index', 'show'],
      'detalles_servicio_productos' => ['index', 'show'],
      
      # Solo lectura para contexto
      'clientes' => ['index', 'show', 'new', 'edit', 'update'],
      'vehiculos' => ['index', 'show', 'new', 'edit', 'update'],
      'productos' => ['index', 'show', 'new', 'edit', 'update'],
      'facturas' => ['index', 'show', 'new', 'edit', 'update'],
      'pedidos' => ['index', 'show', 'new', 'edit', 'update'],
      'proveedores' => ['index', 'show'],
      'servicios' => ['index', 'show'],
      
      # Páginas básicas
      'sessions' => ['destroy'],
      'passwords' => ['edit', 'update']
    }

    unless allowed_actions[controller]&.include?(action)
      redirect_to root_path, alert: 'No tienes permisos para realizar esta acción.'
    end
  end

  def require_admin
    unless current_user&.admin?
      redirect_to root_path, alert: 'Solo los administradores pueden realizar esta acción.'
    end
  end
end
