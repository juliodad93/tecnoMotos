class CreateUsuarios < ActiveRecord::Migration[8.0]
  def change
    create_table :usuarios do |t|
      t.string :nombre, limit: 100
      t.string :apellido, limit: 100
      t.string :identificacion, limit: 20
      t.string :correo, limit: 100
      t.string :cargo, limit: 50
      t.string :password
      t.timestamp :ultimo_acceso

      t.timestamps
    end
    add_index :usuarios, :identificacion, unique: true
    add_index :usuarios, :correo, unique: true
  end
end
