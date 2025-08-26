require "test_helper"

class ServicioTest < ActiveSupport::TestCase
  test "should be valid with valid attributes" do
    servicio = Servicio.new(
      nombre: "Cambio de Aceite",
      precio_base: 50000.00,
      categoria: "Mantenimiento",
      descripcion: "Cambio de aceite del motor"
    )
    assert servicio.valid?
  end

  test "should require nombre" do
    servicio = Servicio.new(
      precio_base: 50000.00,
      categoria: "Mantenimiento"
    )
    assert_not servicio.valid?
    assert_includes servicio.errors[:nombre], "can't be blank"
  end

  test "should require positive precio_base" do
    servicio = Servicio.new(
      nombre: "Servicio Test",
      precio_base: -100.00,
      categoria: "Mantenimiento"
    )
    assert_not servicio.valid?
    assert_includes servicio.errors[:precio_base], "must be greater than 0"
  end

  test "should default activo to true" do
    servicio = Servicio.create!(
      nombre: "Servicio Test",
      precio_base: 50000.00,
      categoria: "Mantenimiento"
    )
    assert servicio.activo?
  end
end
