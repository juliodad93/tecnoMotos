class HomeController < ApplicationController
  skip_before_action :check_authorization
  
  def index
    return redirect_to new_session_path unless user_signed_in?
    
    case current_user.cargo
    when 'administrador'
      redirect_to clientes_path
    when 'tecnico'
      redirect_to detalles_servicio_vehiculos_path
    when 'comercial'
      redirect_to clientes_path # Por ahora, cambiar cuando definamos sus permisos
    when 'administrativo'
      redirect_to clientes_path # Por ahora, cambiar cuando definamos sus permisos
    else
      redirect_to new_session_path, alert: 'Rol de usuario no reconocido.'
    end
  end
end
