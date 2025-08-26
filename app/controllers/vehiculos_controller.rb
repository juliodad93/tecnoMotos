class VehiculosController < ApplicationController
  before_action :set_vehiculo, only: [:show, :edit, :update, :destroy]
  before_action :set_cliente, only: [:new, :create]

  def index
    @vehiculos = Vehiculo.includes(:cliente).all
  end

  def show
  end

  def new
    @vehiculo = @cliente ? @cliente.vehiculos.build : Vehiculo.new
    @clientes = Cliente.all if @cliente.nil?
  end

  def create
    @vehiculo = @cliente ? @cliente.vehiculos.build(vehiculo_params) : Vehiculo.new(vehiculo_params)
    
    if @vehiculo.save
      redirect_to @vehiculo, notice: 'Vehículo creado exitosamente.'
    else
      @clientes = Cliente.all if @cliente.nil?
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @clientes = Cliente.all
  end

  def update
    if @vehiculo.update(vehiculo_params)
      redirect_to @vehiculo, notice: 'Vehículo actualizado exitosamente.'
    else
      @clientes = Cliente.all
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    cliente = @vehiculo.cliente
    @vehiculo.destroy
    redirect_to cliente_path(cliente), notice: 'Vehículo eliminado exitosamente.'
  end

  private

  def set_vehiculo
    @vehiculo = Vehiculo.find(params[:id])
  end

  def set_cliente
    @cliente = Cliente.find(params[:cliente_id]) if params[:cliente_id]
  end

  def vehiculo_params
    params.require(:vehiculo).permit(:matricula, :modelo, :marca, :anio, :color, :descripcion, :cliente_id)
  end
end
