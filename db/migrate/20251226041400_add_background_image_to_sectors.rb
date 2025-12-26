class AddBackgroundImageToSectors < ActiveRecord::Migration[7.0]
  def change
    add_column :sectors, :background_image, :string
  end
end
