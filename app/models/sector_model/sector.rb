class SectorModel::Sector < ApplicationRecord
  self.table_name = 'sectors'
  has_many :systems, inverse_of: :property, dependent: :destroy
  has_many :factions, inverse_of: :property, dependent: :destroy
end
