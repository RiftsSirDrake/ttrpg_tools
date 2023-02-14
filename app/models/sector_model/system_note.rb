class SectorModel::SystemNote < ApplicationRecord
  belongs_to :system
  self.table_name = 'system_notes'
  
  validates :content, presence: true

end
