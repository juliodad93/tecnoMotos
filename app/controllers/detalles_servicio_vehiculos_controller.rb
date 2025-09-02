class DetallesServicioVehiculosController < ApplicationController
  include Authentication
  
  before_action :set_detalle_servicio_vehiculo, only: [:show, :edit, :update, :destroy, :iniciar_servicio, :cerrar_servicio]
  before_action :require_non_tecnico, only: [:new, :create, :destroy]

  def index
    @detalles_servicio_vehiculos = DetalleServicioVehiculo.includes(:servicio, :vehiculo)
                                                          .order(created_at: :desc)
    
    # Los técnicos solo pueden ver servicios no iniciados y en progreso
    if current_user.cargo == 'tecnico'
      @detalles_servicio_vehiculos = @detalles_servicio_vehiculos.where(fecha_fin: nil)
    else
      # Filtros para admins y otros roles
      if params[:estado].present?
        case params[:estado]
        when 'en_progreso'
          @detalles_servicio_vehiculos = @detalles_servicio_vehiculos.where(fecha_fin: nil)
        when 'completado'
          @detalles_servicio_vehiculos = @detalles_servicio_vehiculos.where.not(fecha_fin: nil)
        end
      end
    end
    
    if params[:servicio_id].present?
      @detalles_servicio_vehiculos = @detalles_servicio_vehiculos.where(servicio_id: params[:servicio_id])
    end
    
    if params[:vehiculo_id].present?
      @detalles_servicio_vehiculos = @detalles_servicio_vehiculos.where(vehiculo_id: params[:vehiculo_id])
    end
    
    # Para los filtros
    @servicios = Servicio.activos.order(:nombre)
    @vehiculos = Vehiculo.joins(:cliente).order('clientes.nombre', 'vehiculos.matricula')
    
    # Estadísticas
    @total_servicios = @detalles_servicio_vehiculos.count
    @servicios_no_iniciados = DetalleServicioVehiculo.no_iniciados.count
    @servicios_en_progreso = DetalleServicioVehiculo.en_progreso.count
    @servicios_completados = DetalleServicioVehiculo.completados.count
  end

  def show
    @puede_cerrar = @detalle_servicio_vehiculo.fecha_fin.nil?
  end

  def new
    @detalle_servicio_vehiculo = DetalleServicioVehiculo.new
    @servicios = Servicio.activos.includes(:cliente, :vehiculo).order(:nombre)
    @vehiculos = []
  end

  def create
    @detalle_servicio_vehiculo = DetalleServicioVehiculo.new(detalle_servicio_vehiculo_params)
    # No asignamos fecha_inicio automáticamente, permitimos que se inicie manualmente
    
    if @detalle_servicio_vehiculo.save
      redirect_to detalles_servicio_vehiculo_path(@detalle_servicio_vehiculo), notice: 'Servicio aplicado al vehículo exitosamente.'
    else
      @servicios = Servicio.activos.includes(:cliente, :vehiculo).order(:nombre)
      @vehiculos = @detalle_servicio_vehiculo.servicio ? [@detalle_servicio_vehiculo.servicio.vehiculo] : []
      render :new
    end
  end

  def edit
    # Incluir todos los servicios para permitir editar servicios en progreso, 
    # incluso si el servicio original fue marcado como inactivo
    @servicios = Servicio.all.includes(:cliente, :vehiculo).order(:nombre)
    @vehiculos = [@detalle_servicio_vehiculo.servicio.vehiculo].compact
  end

  def update
    if @detalle_servicio_vehiculo.update(detalle_servicio_vehiculo_params)
      redirect_to detalles_servicio_vehiculo_path(@detalle_servicio_vehiculo), notice: 'Detalle del servicio actualizado exitosamente.'
    else
      @servicios = Servicio.all.includes(:cliente, :vehiculo).order(:nombre)
      @vehiculos = [@detalle_servicio_vehiculo.servicio.vehiculo].compact
      render :edit
    end
  end

  def destroy
    @detalle_servicio_vehiculo.destroy
    redirect_to detalles_servicio_vehiculos_url, notice: 'Detalle del servicio eliminado exitosamente.'
  end
  
  def iniciar_servicio
    if @detalle_servicio_vehiculo.fecha_inicio.present?
      redirect_to detalles_servicio_vehiculo_path(@detalle_servicio_vehiculo), alert: 'Este servicio ya está iniciado.'
      return
    end
    
    @detalle_servicio_vehiculo.update!(fecha_inicio: Time.current)
    redirect_to edit_detalles_servicio_vehiculo_path(@detalle_servicio_vehiculo), notice: 'Servicio iniciado exitosamente. Ahora puedes editarlo.'
  end

  def cerrar_servicio
    if @detalle_servicio_vehiculo.fecha_fin.present?
      redirect_to detalles_servicio_vehiculo_path(@detalle_servicio_vehiculo), alert: 'Este servicio ya está cerrado.'
      return
    end
    
    # Manejar tanto GET como PATCH - ambos redirigen al formulario de productos
    redirect_to new_detalles_servicio_vehiculo_detalles_servicio_producto_path(@detalle_servicio_vehiculo)
  end

  def vehiculo_por_servicio
    servicio = Servicio.find(params[:servicio_id])
    vehiculo = servicio.vehiculo
    if vehiculo
      render json: {
        id: vehiculo.id,
        matricula: vehiculo.matricula,
        marca: vehiculo.marca,
        modelo: vehiculo.modelo,
        anio: vehiculo.anio,
        cliente: {
          nombre: vehiculo.cliente.nombre,
          apellido: vehiculo.cliente.apellido
        }
      }
    else
      render json: { error: "Servicio sin vehículo asociado" }, status: :unprocessable_entity
    end
  end

  private

  def set_detalle_servicio_vehiculo
    @detalle_servicio_vehiculo = DetalleServicioVehiculo.find(params[:id])
  end

  def detalle_servicio_vehiculo_params
    params.require(:detalle_servicio_vehiculo).permit(:servicio_id, :vehiculo_id, :descripcion)
  end

  def require_non_tecnico
    if current_user.cargo == 'tecnico'
      redirect_to detalles_servicio_vehiculos_path, alert: 'Los técnicos no pueden crear o eliminar servicios.'
    end
  end
end
