class SectorModel::System < ApplicationRecord
  belongs_to :sector
  has_many :system_notes, dependent: :destroy
  has_many :system_overrides, dependent: :destroy
  self.table_name = 'systems'
  
  validates :name, presence: true
  validates :location, presence: true, format: { with: /\A\d{4}\z/, message: "must be 4 digits (e.g. 0102)" }, uniqueness: { scope: :sector_id, message: "already exists in this sector" }
  validates :uwp, presence: true, format: { with: /\A[A-X][0-9A-S][0-9A-F][0-9A][0-9A-C][0-9A-F][0-9A-J]-[0-9A-X]\z/, message: "must be in valid UWP format (e.g. A000000-0)" }
  validates :pbg, format: { with: /\A\d{3}\z/, message: "must be 3 digits (e.g. 000)" }, allow_blank: true
  validates :base, length: { maximum: 1 }, allow_blank: true

  include Shared::SystemMapping

  # Start of methods to convert UWP codes into human readable attributes.
  def starport
    unless self.uwp.nil?
    PORT_MAP[self.uwp[0]] if PORT_MAP.key?(self.uwp[0])
    end
  end
  
  def planet_size
    unless self.uwp.nil?
    SIZE_MAP[self.uwp[1]] if SIZE_MAP.key?(self.uwp[1])
  end
  end
  
  def atmosphere
    unless self.uwp.nil?
    ATMO_MAP[self.uwp[2]] if ATMO_MAP.key?(self.uwp[2])
  end
  end
  
  def hydrosphere
    unless self.uwp.nil?
    HYDRO_MAP[self.uwp[3]] if HYDRO_MAP.key?(self.uwp[3])
  end
  end
  
  def pop_base
  end
  
  def population
    unless self.uwp.nil?
    POP_MAP[self.uwp[4]].call(self.pbg) if POP_MAP.key?(self.uwp[4])
  end
  end
  
  def goverment
    unless self.uwp.nil?
    GOV_MAP[self.uwp[5]] if GOV_MAP.key?(self.uwp[5])
  end
  end
  
  def law
    unless self.uwp.nil?
    LAW_MAP[self.uwp[6]] if LAW_MAP.key?(self.uwp[6])
  end
  end
  
  def tech_level
    unless self.uwp.nil?
    TECH_MAP[self.uwp[8]] if TECH_MAP.key?(self.uwp[8])
  end
  end
  
  def bases
    unless self.base.nil?
    BASES_MAP[self.base[0]] if BASES_MAP.key?(self.base[0])
  end
  end

  def notes1
    unless self.notes.nil?
    NOTES_MAP[self.notes[0,2]] if NOTES_MAP.key?(self.notes[0,2])
  end
  end

  def notes2
    unless self.notes.nil?
    NOTES_MAP[self.notes[3,2]] if NOTES_MAP.key?(self.notes[3,2])
  end
  end

  def notes3
    unless self.notes.nil?
    NOTES_MAP[self.notes[6,2]] if NOTES_MAP.key?(self.notes[6,2])
  end
  end
  
  def advisory
    unless self.nil?
    ADVISORY_MAP[self.ring] if ADVISORY_MAP.key?(self.ring)
  end
  end
  
  def asteroid_belts
    unless self.pbg.nil?
    self.pbg[1]
    end
  end
  
  def gas_giants
    unless self.pbg.nil?
    self.pbg[2]
    end
  end

  def self.hexmap(sector_id)
    select("systems.id as id, systems.name as name, systems.location as location, SUM(SUBSTRING(location, 1, 2)) AS q, SUM(SUBSTRING(location, 3, 2) - 41) * -1 AS r, factions.color_code as color_code")
    .joins('left join factions on factions.name = systems.allegiance')
    .where(sector_id: sector_id)
    .group("systems.location, systems.id, systems.name, factions.color_code")
  end

end