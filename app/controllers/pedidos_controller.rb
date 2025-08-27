class PedidosController < ApplicationController
  include Authentication
  
  before_action :set_pedido, only: [:show, :edit, :update, :destroy]

  def index
    @pedidos = Pedido.includes(:proveedor, :user).order(created_at: :desc)
    @pedidos = @pedidos.where(estado: params[:estado]) if params[:estado].present?
    @pedidos = @pedidos.del_proveedor(params[:proveedor_id]) if params[:proveedor_id].present?
    
    @estados = Pedido::ESTADOS
    @proveedores = Proveedor.order(:nombre)
  end

  def show
    @detalles = @pedido.detalles_pedidos.includes(:producto)
  end

  def new
    @pedido = Pedido.new
    @pedido.fecha_pedido = Date.current
    @pedido.estado = 'pendiente'
    @pedido.user = current_user
    
    @proveedores = Proveedor.order(:nombre)
    @productos = Producto.order(:nombre)
  end

  def create
    @pedido = Pedido.new(pedido_params)
    @pedido.user = current_user
    
    if @pedido.save
      redirect_to @pedido, notice: 'Pedido creado exitosamente.'
    else
      @proveedores = Proveedor.order(:nombre)
      @productos = Producto.order(:nombre)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    unless @pedido.puede_editarse?
      redirect_to @pedido, alert: 'Este pedido no se puede editar en su estado actual.'
      return
    end
    
    @proveedores = Proveedor.order(:nombre)
    @productos = Producto.order(:nombre)
  end

  def update
    unless @pedido.puede_editarse?
      redirect_to @pedido, alert: 'Este pedido no se puede editar en su estado actual.'
      return
    end
    
    if @pedido.update(pedido_params)
      redirect_to @pedido, notice: 'Pedido actualizado exitosamente.'
    else
      @proveedores = Proveedor.order(:nombre)
      @productos = Producto.order(:nombre)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    unless @pedido.puede_cancelarse?
      redirect_to @pedido, alert: 'Este pedido no se puede eliminar en su estado actual.'
      return
    end
    
    @pedido.destroy
    redirect_to pedidos_path, notice: 'Pedido eliminado exitosamente.'
  end

  private

  def set_pedido
    @pedido = Pedido.find(params[:id])
  end

  def pedido_params
    params.require(:pedido).permit(:nombre_pedido, :fecha_pedido, :proveedor_id, :total, :estado)
  end
end
