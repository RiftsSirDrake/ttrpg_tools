class SectorPermission < ApplicationRecord
  belongs_to :sector, class_name: 'SectorModel::Sector'
  belongs_to :user
end
