class SectorModel::Faction < ApplicationRecord
  belongs_to :sector
  self.table_name = 'factions'
end
