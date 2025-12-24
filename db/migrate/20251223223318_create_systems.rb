class CreateSystems < ActiveRecord::Migration[7.0]
  def change
    create_table :systems, comment: "Table to hold primary data on systems based on Traveller system and originally generated via random generators like: https://zhodani.space/stuff/generators/random-subsector-generator/ and can be translated into human readable following guidiance here: https://www.traveller-srd.com/core-rules/world-creation/" do |t|
      t.references :sector, null: false, foreign_key: true
      t.string :name, limit: 45, null: false
      t.string :location, limit: 45, null: false
      t.string :uwp, limit: 9
      t.string :base, limit: 1
      t.string :notes, limit: 45
      t.string :ring, limit: 1
      t.string :pbg, limit: 3
      t.string :allegiance, limit: 45
    end
  end
end
