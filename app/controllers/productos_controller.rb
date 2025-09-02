class ProductosController < ApplicationController
  include Authentication
  
  before_action :set_producto, only: [:show, :edit, :update, :destroy]

  def index
    @productos = Producto.includes(:proveedor)
    
    if params[:buscar].present?
      buscar = params[:buscar].strip
      @productos = @productos.where(
        "nombre LIKE ? COLLATE NOCASE OR descripcion LIKE ? COLLATE NOCASE OR sku LIKE ? COLLATE NOCASE",
        "%#{buscar}%", "%#{buscar}%", "%#{buscar}%"
      )
    end
    
    @productos = @productos.order(:nombre)
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
    begin
      @producto.destroy!
      redirect_to productos_path, notice: 'Producto eliminado exitosamente.'
    rescue ActiveRecord::RecordNotDestroyed => e
      redirect_to productos_path, alert: "No se pudo eliminar el producto: #{e.message}"
    rescue StandardError => e
      redirect_to productos_path, alert: "Error inesperado: #{e.message}"
    end
  end

  private

  def set_producto
    @producto = Producto.find(params[:id])
  end

  def producto_params
    params.require(:producto).permit(:nombre, :descripcion, :sku, :cantidad_disponible, :precio_unitario, :precio_venta, :proveedor_id)
  end
end
