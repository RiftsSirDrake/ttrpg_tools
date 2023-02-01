class SectorModel::Sector < ApplicationRecord
  has_many :systems, dependent: :destroy
end
