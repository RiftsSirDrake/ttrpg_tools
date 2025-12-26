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
    PORT_MAP[uwp[0]] if uwp.present?
  end
  
  def planet_size
    SIZE_MAP[uwp[1]] if uwp.present?
  end
  
  def atmosphere
    ATMO_MAP[uwp[2]] if uwp.present?
  end
  
  def hydrosphere
    HYDRO_MAP[uwp[3]] if uwp.present?
  end
  
  def pop_base
  end
  
  def population
    return unless uwp.present?
    val = POP_MAP[uwp[4]]
    val.is_a?(Proc) ? val.call(pbg) : val
  end
  
  def goverment
    GOV_MAP[uwp[5]] if uwp.present?
  end
  
  def law
    LAW_MAP[uwp[6]] if uwp.present?
  end
  
  def tech_level
    TECH_MAP[uwp[8]] if uwp.present?
  end
  
  def bases
    BASES_MAP[base[0]] if base.present?
  end

  def notes1
    NOTES_MAP[notes[0,2]] if notes.present?
  end

  def notes2
    NOTES_MAP[notes[3,2]] if notes.present?
  end

  def notes3
    NOTES_MAP[notes[6,2]] if notes.present?
  end
  
  def advisory
    ADVISORY_MAP[ring]
  end
  
  def asteroid_belts
    pbg[1] if pbg.present?
  end
  
  def gas_giants
    pbg[2] if pbg.present?
  end

  def self.hexmap(sector_id)
    select("systems.id as id, systems.name as name, systems.location as location, SUM(SUBSTRING(location, 1, 2)) AS q, SUM(SUBSTRING(location, 3, 2) - 41) * -1 AS r, factions.color_code as color_code, systems.allegiance as allegiance, systems.uwp as uwp, systems.pbg as pbg, systems.base as base, systems.notes as notes, systems.ring as ring")
    .joins('left join factions on factions.name = systems.allegiance')
    .where(sector_id: sector_id)
    .group("systems.location, systems.id, systems.name, factions.color_code, systems.allegiance, systems.uwp, systems.pbg, systems.base, systems.notes, systems.ring")
  end

end