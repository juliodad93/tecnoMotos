class CreateServiceVehicleDetails < ActiveRecord::Migration[8.0]
  def change
    create_table :service_vehicle_details do |t|
      t.references :service, null: false, foreign_key: true
      t.references :vehicle, null: false, foreign_key: true
      t.text :descripcion
      t.datetime :fecha_inicio
      t.datetime :fecha_fin

      t.timestamps
    end
  end
end
