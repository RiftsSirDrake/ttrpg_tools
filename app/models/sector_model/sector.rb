class SectorModel::Sector < ApplicationRecord
  has_many :systems, inverse_of: :property, dependent: :destroy
end
