class PedidosController < ApplicationController
  include Authentication
  
  before_action :set_pedido, only: [:show, :edit, :update, :destroy, :marcar_como_enviado, :marcar_como_recibido, :marcar_como_completado, :cancelar]

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

  def marcar_como_enviado
    if @pedido.update(estado: 'enviado')
      redirect_to pedidos_path, notice: 'Pedido marcado como enviado exitosamente.'
    else
      redirect_to pedidos_path, alert: 'No se pudo actualizar el estado del pedido.'
    end
  end

  def marcar_como_recibido
    if @pedido.update(estado: 'recibido')
      redirect_to pedidos_path, notice: 'Pedido marcado como recibido exitosamente.'
    else
      redirect_to pedidos_path, alert: 'No se pudo actualizar el estado del pedido.'
    end
  end

  def marcar_como_completado
    if @pedido.update(estado: 'completado')
      redirect_to pedidos_path, notice: 'Pedido marcado como completado exitosamente.'
    else
      redirect_to pedidos_path, alert: 'No se pudo actualizar el estado del pedido.'
    end
  end

  def cancelar
    if @pedido.puede_cancelarse?
      if @pedido.update(estado: 'cancelado')
        redirect_to pedidos_path, notice: 'Pedido cancelado exitosamente.'
      else
        redirect_to pedidos_path, alert: 'No se pudo cancelar el pedido.'
      end
    else
      redirect_to pedidos_path, alert: 'Este pedido no se puede cancelar en su estado actual.'
    end
  end

  private

  def set_pedido
    @pedido = Pedido.find(params[:id])
  end

  def pedido_params
    params.require(:pedido).permit(:nombre_pedido, :fecha_pedido, :proveedor_id, :total, :estado,
                                   detalles_pedidos_attributes: [:id, :producto_id, :cantidad, :precio_unitario, :_destroy])
  end
end
