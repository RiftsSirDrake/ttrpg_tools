class AddTimestampsToAllTables < ActiveRecord::Migration[7.0]
  def change
    add_timestamps :sectors, null: true
    add_timestamps :factions, null: true
    add_timestamps :systems, null: true
    add_timestamps :system_notes, null: true
    add_timestamps :system_overrides, null: true
  end
end
