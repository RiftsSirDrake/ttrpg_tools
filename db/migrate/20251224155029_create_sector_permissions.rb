class CreateSectorPermissions < ActiveRecord::Migration[7.0]
  def change
    create_table :sector_permissions do |t|
      t.references :sector, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.boolean :can_view_sector
      t.boolean :can_edit_sector
      t.boolean :can_view_factions
      t.boolean :can_edit_factions
      t.boolean :can_view_systems
      t.boolean :can_edit_systems
      t.boolean :can_view_system_notes
      t.boolean :can_edit_system_notes

      t.timestamps
    end
  end
end
