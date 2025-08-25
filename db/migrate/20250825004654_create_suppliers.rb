class CreateSuppliers < ActiveRecord::Migration[8.0]
  def change
    create_table :suppliers do |t|
      t.string :nombre
      t.string :identificacion
      t.string :telefono
      t.string :correo
      t.string :direccion
      t.string :persona_contacto
      t.datetime :fecha_registro

      t.timestamps
    end
    add_index :suppliers, :identificacion, unique: true
  end
end
