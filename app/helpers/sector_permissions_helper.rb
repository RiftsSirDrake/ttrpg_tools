module SectorPermissionsHelper
  def can_view_sector?(sector, user)
    return true if sector.public_view == '1'
    return false if user.nil?
    return true if sector.author == user.email || user.admin?
    permission = SectorPermission.find_by(sector: sector, user: user)
    permission&.can_view_sector?
  end

  def can_edit_sector?(sector, user)
    return true if sector.author == user.email || user.admin?
    permission = SectorPermission.find_by(sector: sector, user: user)
    permission&.can_edit_sector?
  end

  def can_view_factions?(sector, user)
    return true if sector.public_view == '1'
    return false if user.nil?
    return true if sector.author == user.email || user.admin?
    permission = SectorPermission.find_by(sector: sector, user: user)
    permission&.can_view_factions?
  end

  def can_edit_factions?(sector, user)
    return true if sector.author == user.email || user.admin?
    permission = SectorPermission.find_by(sector: sector, user: user)
    permission&.can_edit_factions?
  end

  def can_view_systems?(sector, user)
    return true if sector.public_view == '1'
    return false if user.nil?
    return true if sector.author == user.email || user.admin?
    permission = SectorPermission.find_by(sector: sector, user: user)
    permission&.can_view_systems?
  end

  def can_edit_systems?(sector, user)
    return true if sector.author == user.email || user.admin?
    permission = SectorPermission.find_by(sector: sector, user: user)
    permission&.can_edit_systems?
  end

  def can_view_system_notes?(sector, user)
    return true if sector.public_view == '1'
    return false if user.nil?
    return true if sector.author == user.email || user.admin?
    permission = SectorPermission.find_by(sector: sector, user: user)
    permission&.can_view_system_notes?
  end

  def can_edit_system_notes?(sector, user)
    return true if sector.author == user.email || user.admin?
    permission = SectorPermission.find_by(sector: sector, user: user)
    permission&.can_edit_system_notes?
  end

  def visible_system_notes(system, user)
    sector = system.sector
    notes = SectorModel::SystemNote.where(system_id: system.id)
    
    # Admins and Sector Authors see everything
    return notes if user&.admin? || sector.author == user&.email
    
    # Check if user has explicit permission to view ALL notes for this sector
    has_explicit_permission = false
    if user
      permission = SectorPermission.find_by(sector: sector, user: user)
      has_explicit_permission = !!permission&.can_view_system_notes?
    end

    if has_explicit_permission
      notes
    else
      # Otherwise, show public notes OR notes authored by the user
      if user
        notes.where("public_view = '1' OR author = ?", user.email)
      else
        notes.where(public_view: '1')
      end
    end
  end
end
