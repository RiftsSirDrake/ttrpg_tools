class CreateSystemOverrides < ActiveRecord::Migration[7.0]
  def change
    create_table :system_overrides do |t|
      t.integer :sector_id
      t.integer :system_id
      t.string :property
      t.string :value
    end
  end
end
