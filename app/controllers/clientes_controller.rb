class ClientesController < ApplicationController
  before_action :set_cliente, only: [:show, :edit, :update, :destroy]

  def index
    @clientes = Cliente.all
  end

  def show
    @vehiculos = @cliente.vehiculos
  end

  def new
    @cliente = Cliente.new
  end

  def create
    @cliente = Cliente.new(cliente_params)
    
    if @cliente.save
      redirect_to @cliente, notice: 'Cliente creado exitosamente.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @cliente.update(cliente_params)
      redirect_to @cliente, notice: 'Cliente actualizado exitosamente.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @cliente.destroy
    redirect_to clientes_path, notice: 'Cliente eliminado exitosamente.'
  end

  def search
    query = params[:q].to_s.strip
    
    if query.present?
      @clientes = Cliente.where(
        "nombre LIKE ? COLLATE NOCASE OR apellido LIKE ? COLLATE NOCASE OR identificacion LIKE ? COLLATE NOCASE",
        "%#{query}%", "%#{query}%", "%#{query}%"
      ).limit(10)
    else
      @clientes = []
    end

    render json: @clientes.map { |cliente|
      {
        id: cliente.id,
        text: "#{cliente.nombre} #{cliente.apellido} - #{cliente.identificacion}",
        nombre: cliente.nombre,
        apellido: cliente.apellido,
        identificacion: cliente.identificacion,
        telefono: cliente.telefono,
        correo: cliente.correo
      }
    }
  end

  private

  def set_cliente
    @cliente = Cliente.find(params[:id])
  end

  def cliente_params
    params.require(:cliente).permit(:nombre, :apellido, :identificacion, :telefono, :correo, :direccion)
  end
end
