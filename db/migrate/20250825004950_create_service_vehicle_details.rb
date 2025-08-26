class CreateServiceVehicleDetails < ActiveRecord::Migration[8.0]
  def change
    create_table :service_vehicle_details do |t|
      t.references :service, null: true, foreign_key: false # Será agregada después
      t.references :vehiculo, null: false, foreign_key: { to_table: :vehiculos }
      t.text :descripcion
      t.datetime :fecha_inicio
      t.datetime :fecha_fin

      t.timestamps
    end
  end
end
