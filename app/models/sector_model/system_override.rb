class SectorModel::SystemOverride < ApplicationRecord
  belongs_to :system
  self.table_name = 'system_overrides'
end
