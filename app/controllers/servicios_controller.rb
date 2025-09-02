class ServiciosController < ApplicationController
  include Authentication
  
  before_action :set_servicio, only: [:show, :edit, :update, :destroy]

  def index
    @servicios = Servicio.activos.order(:categoria, :nombre)
    @categorias = Servicio.activos.distinct.pluck(:categoria).compact.sort
  end

  def show
  end

  def new
    @servicio = Servicio.new
    @servicio.activo = true
    @clientes = Cliente.order(:nombre, :apellido)
    @vehiculos = []
  end

  def create
    @servicio = Servicio.new(servicio_params)
    @servicio.fecha_registro = Time.current
    
    if @servicio.save
      redirect_to @servicio, notice: 'Servicio creado exitosamente.'
    else
      @clientes = Cliente.order(:nombre, :apellido)
      @vehiculos = @servicio.cliente ? @servicio.cliente.vehiculos.order(:matricula) : []
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @clientes = Cliente.order(:nombre, :apellido)
    @vehiculos = @servicio.cliente ? @servicio.cliente.vehiculos.order(:matricula) : []
  end

  def update
    if @servicio.update(servicio_params)
      redirect_to @servicio, notice: 'Servicio actualizado exitosamente.'
    else
      @clientes = Cliente.order(:nombre, :apellido)
      @vehiculos = @servicio.cliente ? @servicio.cliente.vehiculos.order(:matricula) : []
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # Verificar si el servicio tiene facturas asociadas
    if @servicio.detalles_facturas.exists?
      redirect_to @servicio, alert: 'No se puede eliminar el servicio porque tiene facturas asociadas.'
      return
    end
    
    @servicio.destroy
    redirect_to servicios_path, notice: 'Servicio eliminado exitosamente.'
  end

  def vehiculos_por_cliente
    cliente = Cliente.find(params[:cliente_id])
    vehiculos = cliente.vehiculos.order(:matricula).select(:id, :matricula, :marca, :modelo, :anio)
    render json: vehiculos
  end

  private

  def set_servicio
    @servicio = Servicio.find(params[:id])
  end

  def servicio_params
    params.require(:servicio).permit(:nombre, :descripcion, :precio_base, :duracion_estimada, :categoria, :activo, :cliente_id, :vehiculo_id, :fecha_agendada)
  end
end
