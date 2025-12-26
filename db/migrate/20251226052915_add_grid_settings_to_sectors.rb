class AddGridSettingsToSectors < ActiveRecord::Migration[7.0]
  def change
    add_column :sectors, :show_grid, :boolean
    add_column :sectors, :grid_opacity, :float
  end
end
