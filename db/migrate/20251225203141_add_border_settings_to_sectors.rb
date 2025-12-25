class AddBorderSettingsToSectors < ActiveRecord::Migration[7.0]
  def change
    add_column :sectors, :border_width, :integer
    add_column :sectors, :border_opacity, :float
  end
end
