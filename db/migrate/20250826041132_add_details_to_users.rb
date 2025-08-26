class AddDetailsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :nombre, :string
    add_column :users, :apellido, :string
    add_column :users, :identificacion, :string
    add_column :users, :cargo, :string
  end
end
