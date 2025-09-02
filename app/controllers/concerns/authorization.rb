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
      # Solo servicios aplicados y productos relacionados
      'detalles_servicio_vehiculos' => ['index', 'show', 'edit', 'update', 'iniciar_servicio', 'cerrar_servicio'],
      'detalles_servicio_productos' => ['index', 'show', 'new', 'create', 'edit', 'update', 'destroy', 'finalizar_servicio'],
      'productos' => ['index', 'show', 'new', 'create', 'edit', 'update'],
      
      # Páginas básicas y perfil
      'home' => ['index'],
      'sessions' => ['destroy'],
      'passwords' => ['edit', 'update'],
      'users' => ['show', 'edit', 'update'] # Solo su propio perfil
    }

    unless allowed_actions[controller]&.include?(action)
      redirect_to detalles_servicio_vehiculos_path, alert: 'No tienes permisos para realizar esta acción.'
    end
  end

  def authorize_comercial(controller, action)
    allowed_actions = {
      # Servicios - Solo ver pendientes y cerrar
      'detalles_servicio_vehiculos' => ['index', 'show', 'new', 'create', 'edit', 'update', 'vehiculo_por_servicio'],
      'detalles_servicio_productos' => ['index', 'show'],
      'detalles_facturas' => ['index', 'show', 'new', 'create', 'edit', 'update', 'destroy'],
      'detalles_pedidos' => ['index', 'show', 'new', 'create', 'edit', 'update', 'destroy'],
      
      # Solo lectura para contexto
      'clientes' => ['index', 'show', 'new', 'create', 'edit', 'update', 'search'],
      'vehiculos' => ['index', 'show', 'new', 'create', 'edit', 'update'],
      'productos' => ['index', 'show', 'new', 'create', 'edit', 'update'],
      'facturas' => ['index', 'show', 'new', 'create', 'edit', 'update', 'desde_servicios', 'crear_desde_servicio', 'marcar_como_pagada', 'anular'],
      'pedidos' => ['index', 'show', 'new', 'create', 'edit', 'update', 'productos_por_proveedor', 'marcar_como_enviado', 'marcar_como_recibido', 'marcar_como_completado', 'cancelar'],
      'servicios' => ['index', 'show', 'new', 'create', 'edit', 'update', 'vehiculos_por_cliente'],
      
      # Páginas básicas y perfil propio
      'home' => ['index'],
      'sessions' => ['destroy'],
      'passwords' => ['edit', 'update'],
      'users' => ['show', 'edit', 'update'] # Solo su propio perfil
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
