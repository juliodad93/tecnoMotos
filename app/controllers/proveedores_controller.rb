class ProveedoresController < ApplicationController
  before_action :set_proveedor, only: [:show, :edit, :update, :destroy]

  def index
    @proveedores = Proveedor.all.order(:nombre)
  end

  def show
  end

  def new
    @proveedor = Proveedor.new
  end

  def create
    @proveedor = Proveedor.new(proveedor_params)
    
    if @proveedor.save
      redirect_to proveedore_path(@proveedor), notice: 'Proveedor creado exitosamente.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @proveedor.update(proveedor_params)
      redirect_to proveedore_path(@proveedor), notice: 'Proveedor actualizado exitosamente.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @proveedor.destroy
    redirect_to proveedores_path, notice: 'Proveedor eliminado exitosamente.'
  end

  private

  def set_proveedor
    @proveedor = Proveedor.find(params[:id])
  end

  def proveedor_params
    params.require(:proveedor).permit(:nombre, :identificacion, :telefono, :correo, :direccion, :persona_contacto)
  end
end
