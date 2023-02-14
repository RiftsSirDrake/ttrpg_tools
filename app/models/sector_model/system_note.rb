class SectorModel::SystemNote < ApplicationRecord
  belongs_to :system
  self.table_name = 'system_notes'
  
  validates :content, presence: true
  validates_length_of :content, minimum: 5, maximum: 512
  
end
