class AddFechaAgendadaToServicios < ActiveRecord::Migration[8.0]
  def change
    add_column :servicios, :fecha_agendada, :datetime
  end
end
