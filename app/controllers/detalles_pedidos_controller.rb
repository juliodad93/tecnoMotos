class DetallesPedidosController < ApplicationController
  before_action :set_pedido
  before_action :set_detalle_pedido, only: [:show, :edit, :update, :destroy]

  def index
    @detalles_pedidos = @pedido.detalles_pedidos.includes(:producto)
  end

  def show
  end

  def new
    @detalle_pedido = @pedido.detalles_pedidos.build
    @productos = Producto.includes(:proveedor).order(:nombre)
  end

  def create
    @detalle_pedido = @pedido.detalles_pedidos.build(detalle_pedido_params)
    
    if @detalle_pedido.save
      # Recalcular el total del pedido
      @pedido.save! # Esto activará el callback calcular_total
      redirect_to pedido_path(@pedido), notice: 'Producto agregado al pedido exitosamente.'
    else
      @productos = Producto.includes(:proveedor).order(:nombre)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @productos = Producto.includes(:proveedor).order(:nombre)
  end

  def update
    if @detalle_pedido.update(detalle_pedido_params)
      # Recalcular el total del pedido
      @pedido.save! # Esto activará el callback calcular_total
      redirect_to pedido_path(@pedido), notice: 'Producto actualizado exitosamente.'
    else
      @productos = Producto.includes(:proveedor).order(:nombre)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @detalle_pedido.destroy
    # Recalcular el total del pedido
    @pedido.save! # Esto activará el callback calcular_total
    redirect_to pedido_path(@pedido), notice: 'Producto eliminado del pedido.'
  end

  private

  def set_pedido
    @pedido = Pedido.find(params[:pedido_id])
  end

  def set_detalle_pedido
    @detalle_pedido = DetallePedido.find(params[:id])
  end

  def detalle_pedido_params
    params.require(:detalle_pedido).permit(:producto_id, :cantidad, :precio_unitario)
  end
end