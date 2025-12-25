class AddHexColorToSectors < ActiveRecord::Migration[7.0]
  def change
    add_column :sectors, :hex_color, :string
  end
end
