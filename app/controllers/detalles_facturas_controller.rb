class DetallesFacturasController < ApplicationController
  include Authentication
  
  before_action :set_factura
  before_action :set_detalle_factura, only: [:show, :edit, :update, :destroy]

  def index
    @detalles = @factura.detalles_facturas.includes(:producto).order(:id)
  end

  def show
  end

  def new
    @detalle_factura = @factura.detalles_facturas.build
    @productos = Producto.order(:nombre)
    @servicios = Servicio.order(:nombre) if defined?(Servicio)
    @trabajos_facturables = DetalleServicioVehiculo.completados
                                                   .includes(:vehiculo)
                                                   .where.not(id: DetalleFactura.select(:detalle_servicio_vehiculo_id).where.not(detalle_servicio_vehiculo_id: nil))
                                                   .order(:created_at)
  end

  def create
    @detalle_factura = @factura.detalles_facturas.build(detalle_factura_params)
    
    if @detalle_factura.save
      # Recalcular totales de la factura
      @factura.calcular_totales!
      redirect_to factura_detalles_factura_path(@factura, @detalle_factura), notice: 'Detalle agregado exitosamente.'
    else
      @productos = Producto.order(:nombre)
      @servicios = Servicio.order(:nombre) if defined?(Servicio)
      @trabajos_facturables = DetalleServicioVehiculo.completados
                                                     .includes(:vehiculo)
                                                     .where.not(id: DetalleFactura.select(:detalle_servicio_vehiculo_id).where.not(detalle_servicio_vehiculo_id: nil))
                                                     .order(:created_at)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @productos = Producto.order(:nombre)
    @servicios = Servicio.order(:nombre) if defined?(Servicio)
    @trabajos_facturables = DetalleServicioVehiculo.completados
                                                   .includes(:vehiculo)
                                                   .where.not(id: DetalleFactura.select(:detalle_servicio_vehiculo_id).where.not(detalle_servicio_vehiculo_id: nil))
                                                   .or(DetalleServicioVehiculo.where(id: @detalle_factura.detalle_servicio_vehiculo_id))
                                                   .order(:created_at)
  end

  def update
    if @detalle_factura.update(detalle_factura_params)
      # Recalcular totales de la factura
      @factura.calcular_totales!
      redirect_to factura_detalles_factura_path(@factura, @detalle_factura), notice: 'Detalle actualizado exitosamente.'
    else
      @productos = Producto.order(:nombre)
      @servicios = Servicio.order(:nombre) if defined?(Servicio)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @detalle_factura.destroy!
    # Recalcular totales de la factura
    @factura.calcular_totales!
    redirect_to @factura, notice: 'Detalle eliminado exitosamente.'
  end

  private

  def set_factura
    @factura = Factura.find(params[:factura_id])
  end

  def set_detalle_factura
    @detalle_factura = @factura.detalles_facturas.find(params[:id])
  end

  def detalle_factura_params
    params.require(:detalle_factura).permit(:producto_id, :servicio_id, :detalle_servicio_vehiculo_id,
                                           :descripcion, :cantidad, :costo_item, :tipo_item)
  end
end
