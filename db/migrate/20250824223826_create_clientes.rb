class CreateClientes < ActiveRecord::Migration[8.0]
  def change
    create_table :clientes do |t|
      t.string :nombre
      t.string :apellido
      t.string :identificacion
      t.string :telefono
      t.string :correo
      t.string :direccion
      t.datetime :fecha_registro

      t.timestamps
    end
    add_index :clientes, :identificacion, unique: true
  end
end
