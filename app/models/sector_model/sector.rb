class SectorModel::Sector < ApplicationRecord
  self.table_name = 'sectors'
  has_many :systems, dependent: :destroy
  has_many :factions, dependent: :destroy
  has_many :sector_permissions, foreign_key: :sector_id, dependent: :destroy
  has_many :permitted_users, through: :sector_permissions, source: :user
end
