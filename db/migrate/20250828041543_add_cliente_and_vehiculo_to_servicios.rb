class AddClienteAndVehiculoToServicios < ActiveRecord::Migration[8.0]
  def change
    add_reference :servicios, :cliente, null: true, foreign_key: true
    add_reference :servicios, :vehiculo, null: true, foreign_key: true
  end
end
