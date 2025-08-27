class ServiciosController < ApplicationController
  include Authentication
  
  before_action :set_servicio, only: [:show, :edit, :update, :destroy]

  def index
    @servicios = Servicio.all.order(:categoria, :nombre)
    @categorias = Servicio.distinct.pluck(:categoria).compact.sort
  end

  def show
  end

  def new
    @servicio = Servicio.new
    @servicio.activo = true
  end

  def create
    @servicio = Servicio.new(servicio_params)
    @servicio.fecha_registro = Time.current
    
    if @servicio.save
      redirect_to @servicio, notice: 'Servicio creado exitosamente.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @servicio.update(servicio_params)
      redirect_to @servicio, notice: 'Servicio actualizado exitosamente.'
    else
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

  private

  def set_servicio
    @servicio = Servicio.find(params[:id])
  end

  def servicio_params
    params.require(:servicio).permit(:nombre, :descripcion, :precio_base, :duracion_estimada, :categoria, :activo)
  end
end
