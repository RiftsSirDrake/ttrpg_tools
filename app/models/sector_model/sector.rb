class SectorModel::Sector < ApplicationRecord
  self.table_name = 'sectors'
  has_many :systems, dependent: :destroy
  has_many :factions, dependent: :destroy
  has_many :sector_permissions, foreign_key: :sector_id, dependent: :destroy
  has_many :permitted_users, through: :sector_permissions, source: :user

  validates :border_width, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 20 }, allow_nil: true
  validates :border_opacity, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }, allow_nil: true
  validates :grid_opacity, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }, allow_nil: true
  validates :show_grid, inclusion: { in: [true, false] }, allow_nil: true
end
