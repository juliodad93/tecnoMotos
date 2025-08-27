class ProductosController < ApplicationController
  before_action :set_producto, only: [:show, :edit, :update, :destroy]

  def index
    @productos = Producto.includes(:proveedor).order(:nombre)
  end

  def show
  end

  def new
    @producto = Producto.new
  end

  def create
    @producto = Producto.new(producto_params)
    
    if @producto.save
      redirect_to @producto, notice: 'Producto creado exitosamente.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @producto.update(producto_params)
      redirect_to @producto, notice: 'Producto actualizado exitosamente.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @producto.destroy
    redirect_to productos_path, notice: 'Producto eliminado exitosamente.'
  end

  private

  def set_producto
    @producto = Producto.find(params[:id])
  end

  def producto_params
    params.require(:producto).permit(:nombre, :descripcion, :sku, :cantidad_disponible, :precio_unitario, :precio_venta, :proveedor_id)
  end
end
