class CreateFactions < ActiveRecord::Migration[7.0]
  def change
    create_table :factions do |t|
      t.references :sector, null: false, foreign_key: true
      t.string :name
      t.text :description
      t.string :color_code
    end
  end
end
