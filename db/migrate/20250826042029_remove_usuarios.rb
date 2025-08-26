class RemoveUsuarios < ActiveRecord::Migration[8.0]
  def change
    drop_table :usuarios
  end
end
