class CreateSystemNotes < ActiveRecord::Migration[7.0]
  def change
    create_table :system_notes do |t|
      t.integer :sector_id
      t.integer :system_id
      t.string :author
      t.binary :public_view
    end
  end
end
