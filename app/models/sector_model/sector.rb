class SectorModel::Sector < ApplicationRecord
  self.table_name = 'sectors'
  has_many :systems, dependent: :destroy
  has_many :factions, dependent: :destroy
end
