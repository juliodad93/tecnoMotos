class FacturasController < ApplicationController
  include Authentication
  
  before_action :set_factura, only: [:show, :edit, :update, :destroy, :marcar_como_pagada, :anular]

  def index
    @facturas = Factura.includes(:cliente, :user).order(created_at: :desc)
    
    # Búsqueda por cliente
    if params[:buscar].present?
      buscar = params[:buscar].strip
      @facturas = @facturas.joins(:cliente).where(
        "clientes.nombre LIKE ? COLLATE NOCASE OR clientes.apellido LIKE ? COLLATE NOCASE OR clientes.identificacion LIKE ? COLLATE NOCASE",
        "%#{buscar}%", "%#{buscar}%", "%#{buscar}%"
      )
    end
    
    # Filtros
    @facturas = @facturas.where(estado: params[:estado]) if params[:estado].present?
    
    # Filtro por mes/año
    if params[:mes].present? && params[:año].present?
      fecha_inicio = Date.new(params[:año].to_i, params[:mes].to_i, 1)
      fecha_fin = fecha_inicio.end_of_month
      @facturas = @facturas.where(fecha_factura: fecha_inicio..fecha_fin)
    end
    
    # Estadísticas
    @total_facturas = @facturas.count
    @total_pendientes = @facturas.where(estado: 'pendiente').count
    @total_pagadas = @facturas.where(estado: 'pagada').count
    @monto_total = @facturas.sum(:total)
    @monto_pendiente = @facturas.where(estado: 'pendiente').sum(:total)
    
    @estados = ['pendiente', 'pagada', 'anulada']
    @clientes = Cliente.order(:nombre, :apellido)
    @meses = (1..12).map { |m| [Date::MONTHNAMES[m], m] }
    @años = (Date.current.year - 2..Date.current.year + 1).to_a.reverse
  end

  def show
    @detalles = @factura.detalles_facturas.includes(:producto).order(:id)
    
    # Si la factura está anulada, mostrar solo información
    if @factura.anulada?
      flash.now[:alert] = 'Esta factura ha sido anulada y no puede ser modificada.'
    end
  end

  def new
    @factura = Factura.new
    @factura.fecha_factura = Date.current
    @factura.estado = 'pendiente'
    @factura.user = current_user
    
    # El número de factura se genera automáticamente en el modelo
    
    @clientes = Cliente.order(:nombre, :apellido)
    @productos = Producto.order(:nombre)
    
    # Si viene de servicios, precargar información
    if params[:detalle_servicio_vehiculo_id].present?
      trabajo = DetalleServicioVehiculo.find(params[:detalle_servicio_vehiculo_id])
      @factura.cliente = trabajo.vehiculo.cliente
      
      # Preparar el detalle precargado
      @detalle_precargado = {
        detalle_servicio_vehiculo_id: trabajo.id,
        descripcion: trabajo.descripcion,
        cantidad: 1,
        costo_item: trabajo.duracion_horas * 50000, # Precio sugerido
        tipo_item: 'servicio_vehiculo'
      }
    elsif params[:cliente_id].present? && params[:trabajos_ids].present?
      @factura.cliente_id = params[:cliente_id]
      trabajos_ids = params[:trabajos_ids].split(',').map(&:to_i)
      @trabajos_precargados = DetalleServicioVehiculo.where(id: trabajos_ids)
    end
  end

  def create
    @factura = Factura.new(factura_params)
    @factura.user = current_user
    
    # El número de factura se genera automáticamente en el modelo
    
    if @factura.save
      redirect_to @factura, notice: 'Factura creada exitosamente.'
    else
      @clientes = Cliente.order(:nombre, :apellido)
      @productos = Producto.order(:nombre)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    if @factura.pagada? || @factura.anulada?
      redirect_to @factura, alert: 'No se puede editar una factura pagada o anulada.'
      return
    end
    
    @clientes = Cliente.order(:nombre, :apellido)
    @productos = Producto.order(:nombre)
  end

  def update
    if @factura.pagada? || @factura.anulada?
      redirect_to @factura, alert: 'No se puede modificar una factura pagada o anulada.'
      return
    end
    
    if @factura.update(factura_params)
      redirect_to @factura, notice: 'Factura actualizada exitosamente.'
    else
      @clientes = Cliente.order(:nombre, :apellido)
      @productos = Producto.order(:nombre)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @factura.pagada?
      redirect_to @factura, alert: 'No se puede eliminar una factura que ya está pagada.'
      return
    end
    
    @factura.destroy!
    redirect_to facturas_path, notice: 'Factura eliminada exitosamente.'
  end

  def marcar_como_pagada
    if @factura.anulada?
      redirect_to @factura, alert: 'No se puede marcar como pagada una factura anulada.'
      return
    end
    
    if @factura.pagada?
      redirect_to @factura, alert: 'Esta factura ya está marcada como pagada.'
      return
    end
    
    @factura.update!(estado: 'pagada', fecha_pago: Date.current)
    redirect_to @factura, notice: 'Factura marcada como pagada exitosamente.'
  end

  def anular
    if @factura.pagada?
      redirect_to @factura, alert: 'No se puede anular una factura que ya está pagada.'
      return
    end
    
    if @factura.anulada?
      redirect_to @factura, alert: 'Esta factura ya está anulada.'
      return
    end
    
    @factura.update!(estado: 'anulada', fecha_anulacion: Date.current)
    redirect_to @factura, notice: 'Factura anulada exitosamente.'
  end

  def desde_servicios
    # Obtener trabajos completados y no facturados, agrupados por cliente
    @trabajos_por_cliente = DetalleServicioVehiculo.completados
                                                   .includes(:vehiculo, :servicio, vehiculo: :cliente)
                                                   .where.not(id: DetalleFactura.select(:detalle_servicio_vehiculo_id).where.not(detalle_servicio_vehiculo_id: nil))
                                                   .group_by { |t| t.vehiculo.cliente }
                                                   .sort_by { |cliente, _| "#{cliente.nombre} #{cliente.apellido}" }
  end

  def crear_desde_servicio
    @servicio_detalle = DetalleServicioVehiculo.find(params[:servicio_id])
    
    unless @servicio_detalle.puede_facturarse?
      if @servicio_detalle.en_progreso?
        redirect_to detalles_servicio_vehiculo_path(@servicio_detalle), alert: 'El servicio debe estar completado para crear una factura.'
      else
        redirect_to detalles_servicio_vehiculo_path(@servicio_detalle), alert: 'Este servicio ya ha sido facturado.'
      end
      return
    end
    
    # Verificar si ya existe una factura para este servicio
    factura_existente = Factura.joins(:detalles_facturas)
                              .where(detalles_facturas: { detalle_servicio_vehiculo_id: @servicio_detalle.id })
                              .first
                              
    if factura_existente
      redirect_to factura_existente, alert: 'Ya existe una factura para este servicio.'
      return
    end
    
    @factura = Factura.new
    @factura.cliente = @servicio_detalle.cliente
    @factura.fecha_factura = Date.current
    @factura.estado = 'pendiente'
    @factura.user = current_user
    @factura.metodo_pago = 'efectivo'
    # Valores temporales para pasar validaciones
    @factura.subtotal = 0.01
    @factura.total = 0.01
    
    if @factura.save
      # Crear detalle para el servicio
      detalle_servicio = @factura.detalles_facturas.create!(
        producto_id: nil, # Es un servicio, no un producto
        servicio_id: nil, # No usamos esto para servicios de vehículo
        detalle_servicio_vehiculo_id: @servicio_detalle.id,
        descripcion: "Servicio: #{@servicio_detalle.servicio.nombre}",
        cantidad: 1,
        costo_item: @servicio_detalle.servicio.precio_base,
        tipo_item: 'servicio_vehiculo'
      )
      
      # Crear detalles para los productos usados
      @servicio_detalle.servicio.detalles_servicio_productos.each do |producto_servicio|
        @factura.detalles_facturas.create!(
          producto_id: producto_servicio.producto_id,
          servicio_id: nil,
          detalle_servicio_vehiculo_id: nil,
          descripcion: producto_servicio.producto.nombre,
          cantidad: producto_servicio.cantidad_usada,
          costo_item: producto_servicio.precio_unitario,
          tipo_item: 'producto'
        )
      end
      
      # Calcular totales correctos y guardar
      @factura.calcular_totales!
      
      redirect_to @factura, notice: 'Factura creada exitosamente desde el servicio.'
    else
      errors = @factura.errors.full_messages.join(', ')
      redirect_to detalles_servicio_vehiculo_path(@servicio_detalle), alert: "Error al crear la factura inicial: #{errors}"
    end
  end

  private

  def set_factura
    @factura = Factura.find(params[:id])
  end

  def factura_params
    params.require(:factura).permit(:fecha_factura, :cliente_id, :subtotal, 
                                   :impuestos, :total, :metodo_pago, :estado)
  end
end
