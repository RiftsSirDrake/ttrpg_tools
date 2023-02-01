class SectorModel::System < ApplicationRecord
  belongs_to :sector
  has_many :system_notes, dependent: :destroy
  has_many :system_overrides, dependent: :destroy
  
  include Shared::SystemMapping

  # Start of methods to convert UWP codes into human readable attributes.
  def starport
    PORT_MAP[self.uwp[0]] if PORT_MAP.key?(self.uwp[0])
  end
  
  def planet_size
    SIZE_MAP[self.uwp[1]] if SIZE_MAP.key?(self.uwp[1])
  end
  
  def atmosphere
    ATMO_MAP[self.uwp[2]] if ATMO_MAP.key?(self.uwp[2])
  end
  
  def hydrosphere
    HYDRO_MAP[self.uwp[3]] if HYDRO_MAP.key?(self.uwp[3])
  end
  
  def population
    POP_MAP[self.uwp[4]].call(self.pbg) if POP_MAP.key?(self.uwp[4])
  end
  
  def goverment
    GOV_MAP[self.uwp[5]] if GOV_MAP.key?(self.uwp[5])
  end
  
  def law
    LAW_MAP[self.uwp[6]] if LAW_MAP.key?(self.uwp[6])
  end
  
  def tech_level
    TECH_MAP[self.uwp[8]] if TECH_MAP.key?(self.uwp[8])
  end
  
  def bases
    BASES_MAP[self.base[0]] if BASES_MAP.key?(self.base[0])
  end

  def notes1
    NOTES_MAP[self.notes[0,2]] if NOTES_MAP.key?(self.notes[0,2])
  end

  def notes2
    NOTES_MAP[self.notes[3,2]] if NOTES_MAP.key?(self.notes[3,2])
  end

  def notes3
    NOTES_MAP[self.notes[6,2]] if NOTES_MAP.key?(self.notes[6,2])
  end
  
  def advisory
    ADVISORY_MAP[self.ring[0]] if ADVISORY_MAP.key?(self.ring[0])
  end
  
  def asteroid_belts
    self.pbg[1]
  end
  
  def gas_giants
    self.pbg[2]
  end

  def self.hexmap
    select("location, name, SUM(SUBSTRING(location, 1, 2)) AS q, SUM(SUBSTRING(location, 3, 2) - 41) * -1 AS r")
    .group(:location)
  end

end
