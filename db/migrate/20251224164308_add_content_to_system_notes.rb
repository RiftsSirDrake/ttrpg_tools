class AddContentToSystemNotes < ActiveRecord::Migration[7.0]
  def change
    add_column :system_notes, :content, :text
  end
end
