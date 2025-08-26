require "test_helper"

class ProductoTest < ActiveSupport::TestCase
  def setup
    @proveedor = Proveedor.create!(
      nombre: "Proveedor Test",
      identificacion: "123456789",
      telefono: "555-1234",
      correo: "test@proveedor.com"
    )
  end

  test "should be valid with valid attributes" do
    producto = Producto.new(
      nombre: "Producto Test",
      sku: "TEST001",
      cantidad_disponible: 10,
      precio_unitario: 100.50,
      precio_venta: 150.75,
      proveedor: @proveedor
    )
    assert producto.valid?
  end

  test "should require nombre" do
    producto = Producto.new(
      sku: "TEST001",
      cantidad_disponible: 10,
      precio_unitario: 100.50,
      precio_venta: 150.75,
      proveedor: @proveedor
    )
    assert_not producto.valid?
    assert_includes producto.errors[:nombre], "can't be blank"
  end

  test "should require unique sku" do
    Producto.create!(
      nombre: "Producto 1",
      sku: "TEST001",
      cantidad_disponible: 10,
      precio_unitario: 100.50,
      precio_venta: 150.75,
      proveedor: @proveedor
    )
    
    producto2 = Producto.new(
      nombre: "Producto 2",
      sku: "TEST001",
      cantidad_disponible: 5,
      precio_unitario: 200.00,
      precio_venta: 300.00,
      proveedor: @proveedor
    )
    
    assert_not producto2.valid?
    assert_includes producto2.errors[:sku], "has already been taken"
  end
end
