class DetallesServicioProductosController < ApplicationController
  include Authentication
  
  before_action :set_detalle_servicio_vehiculo
  before_action :set_detalle_servicio_producto, only: [:edit, :update, :destroy]

  def index
    @detalles_servicio_productos = @detalle_servicio_vehiculo.servicio.detalles_servicio_productos
                                                                      .includes(:producto)
                                                                      .order(:created_at)
  end

  def new
    @detalle_servicio_producto = DetalleServicioProducto.new
    @productos = Producto.order(:nombre)
  end

  def create
    @detalle_servicio_producto = DetalleServicioProducto.new(detalle_servicio_producto_params)
    @detalle_servicio_producto.servicio = @detalle_servicio_vehiculo.servicio
    
    if @detalle_servicio_producto.save
      # Actualizar el stock del producto
      producto = @detalle_servicio_producto.producto
      if producto.cantidad_disponible >= @detalle_servicio_producto.cantidad_usada
        producto.update!(
          cantidad_disponible: producto.cantidad_disponible - @detalle_servicio_producto.cantidad_usada
        )
        
        redirect_to new_detalles_servicio_vehiculo_detalles_servicio_producto_path(@detalle_servicio_vehiculo), 
                    notice: "Producto #{producto.nombre} agregado al servicio. Stock actualizado."
      else
        @detalle_servicio_producto.destroy
        redirect_to new_detalles_servicio_vehiculo_detalles_servicio_producto_path(@detalle_servicio_vehiculo), 
                    alert: "No hay suficiente stock del producto #{producto.nombre}. Disponible: #{producto.cantidad_disponible}"
      end
    else
      @productos = Producto.order(:nombre)
      render :new
    end
  end

  def edit
    @productos = Producto.order(:nombre)
  end

  def update
    cantidad_anterior = @detalle_servicio_producto.cantidad_usada
    
    if @detalle_servicio_producto.update(detalle_servicio_producto_params)
      # Ajustar el stock
      diferencia = @detalle_servicio_producto.cantidad_usada - cantidad_anterior
      producto = @detalle_servicio_producto.producto
      nuevo_stock = producto.cantidad_disponible - diferencia
      
      if nuevo_stock >= 0
        producto.update!(cantidad_disponible: nuevo_stock)
        redirect_to detalles_servicio_vehiculo_detalles_servicio_productos_path(@detalle_servicio_vehiculo), 
                    notice: 'Producto actualizado exitosamente.'
      else
        @detalle_servicio_producto.update!(cantidad_usada: cantidad_anterior)
        redirect_to edit_detalles_servicio_vehiculo_detalles_servicio_producto_path(@detalle_servicio_vehiculo, @detalle_servicio_producto), 
                    alert: "No hay suficiente stock. Disponible: #{producto.cantidad_disponible + cantidad_anterior}"
      end
    else
      @productos = Producto.order(:nombre)
      render :edit
    end
  end

  def destroy
    # Devolver el stock
    producto = @detalle_servicio_producto.producto
    producto.update!(
      cantidad_disponible: producto.cantidad_disponible + @detalle_servicio_producto.cantidad_usada
    )
    
    @detalle_servicio_producto.destroy
    redirect_to detalles_servicio_vehiculo_detalles_servicio_productos_path(@detalle_servicio_vehiculo), 
                notice: 'Producto eliminado del servicio y stock restaurado.'
  end

  def finalizar_servicio
    # Verificar que hay productos registrados
    if @detalle_servicio_vehiculo.servicio.detalles_servicio_productos.empty?
      redirect_to new_detalles_servicio_vehiculo_detalles_servicio_producto_path(@detalle_servicio_vehiculo), 
                  alert: 'Debes registrar al menos un producto utilizado antes de cerrar el servicio.'
      return
    end
    
    # Cerrar el servicio
    @detalle_servicio_vehiculo.update!(fecha_fin: Time.current)
    redirect_to detalles_servicio_vehiculo_path(@detalle_servicio_vehiculo), 
                notice: 'Servicio cerrado exitosamente con productos registrados.'
  end

  private

  def set_detalle_servicio_vehiculo
    @detalle_servicio_vehiculo = DetalleServicioVehiculo.find(params[:detalles_servicio_vehiculo_id])
  end

  def set_detalle_servicio_producto
    @detalle_servicio_producto = DetalleServicioProducto.find(params[:id])
  end

  def detalle_servicio_producto_params
    params.require(:detalle_servicio_producto).permit(:producto_id, :cantidad_usada, :precio_unitario)
  end
end
