require "test_helper"

class ProveedorTest < ActiveSupport::TestCase
  test "should be valid with valid attributes" do
    proveedor = Proveedor.new(
      nombre: "Proveedor Test",
      identificacion: "123456789",
      telefono: "555-1234",
      correo: "test@proveedor.com",
      direccion: "Calle 123"
    )
    assert proveedor.valid?
  end

  test "should require nombre" do
    proveedor = Proveedor.new(identificacion: "123456789", telefono: "555-1234", correo: "test@proveedor.com")
    assert_not proveedor.valid?
    assert_includes proveedor.errors[:nombre], "can't be blank"
  end

  test "should require unique identificacion" do
    Proveedor.create!(
      nombre: "Proveedor 1",
      identificacion: "123456789",
      telefono: "555-1234",
      correo: "test1@proveedor.com"
    )
    
    proveedor2 = Proveedor.new(
      nombre: "Proveedor 2",
      identificacion: "123456789",
      telefono: "555-5678",
      correo: "test2@proveedor.com"
    )
    
    assert_not proveedor2.valid?
    assert_includes proveedor2.errors[:identificacion], "has already been taken"
  end
end
