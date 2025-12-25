require 'roo'

class Sector::SystemsController < ApplicationController
  before_action :check_member, only: [:new, :edit, :update, :destroy]
  include Shared::SystemMapping
  include Sector::SystemsHelper
  
  def index
    @sector = SectorModel::Sector.find(params[:sector_id])
    if can_view_systems?(@sector, current_user)
      @systems = SectorModel::System.where("sector_id = ?", params[:sector_id])
    else
      redirect_back_or_to sector_path(@sector), alert: "You do not have permission to view systems for this sector."
    end
  end

  def bulk_upload
    @sector = SectorModel::Sector.find(params[:sector_id])
    unless can_edit_systems?(@sector, current_user)
      redirect_back_or_to systems_path(sector_id: params[:sector_id]), alert: "You do not have permission to edit systems."
    end
  end

  # TODO: bulk upload is not properly handling bases, traits, asteroid, and gas giants
  def process_bulk_upload
    @sector = SectorModel::Sector.find(params[:sector_id])
    
    if can_edit_systems?(@sector, current_user)
      file = params[:file]
      if file.present? && (file.path.ends_with?('.xlsx') || file.path.ends_with?('.csv'))
        if file.path.ends_with?('.xlsx')
          xlsx = Roo::Excelx.new(file.path)
          sheet = xlsx.sheet(0)
        else
          sheet = Roo::CSV.new(file.path)
        end
        
        errors = []
        systems_count = 0
        duplicates = []
        systems_to_create = []
        
        # Pass 1: Validation
        sheet.each_with_index do |row, index|
          # Skip header row if it exists
          if index == 0
            check_location = row[1].to_s.gsub('.0', '').rjust(4, '0')
            is_header = row[0].to_s.downcase == 'name' || 
                       row[1].to_s.downcase == 'location' || 
                       row[3].to_s.downcase == 'base' ||
                       !(check_location =~ /\A\d{4}\z/)
            next if is_header
          end

          name = row[0]
          location = row[1].to_s.gsub('.0', '').rjust(4, '0')
          uwp = row[2]
          
          # Basic presence check for critical fields before creating model instance
          if name.blank? && uwp.blank?
            next # Skip truly empty rows
          end
          
          base = row[3] || ""
          notes = "#{row[4]} #{row[5]}".rstrip
          ring = row[6] || ""
          pbg_raw = row[7] || "000"
          pbg = pbg_raw.to_s.rjust(3, '0')

          system = SectorModel::System.new(
            sector: @sector,
            name: name,
            location: location,
            uwp: uwp,
            base: base,
            notes: notes,
            ring: ring,
            pbg: pbg
          )

          if system.invalid? || systems_to_create.any? { |s| s.location == location }
            # Only treat as duplicate if it's actually valid otherwise or if the ONLY error is the location uniqueness
            is_duplicate = system.errors[:location].include?("already exists in this sector") || systems_to_create.any? { |s| s.location == location }
            has_other_errors = system.errors.details.keys.any? { |key| key != :location }
            
            if is_duplicate && !has_other_errors
              duplicates << location
            else
              errors << "Row #{index + 1} (#{name || 'Unknown'}): #{system.errors.full_messages.join(', ')}"
            end
          else
            systems_to_create << system
          end
        end

        # Pass 2: Insertion (only if no validation errors, duplicates are allowed to be ignored)
        if errors.empty?
          SectorModel::System.transaction do
            systems_to_create.each do |system|
              if system.save
                systems_count += 1
              else
                # This shouldn't happen if valid? passed, but safety first
                errors << "Row for #{system.name} failed to save: #{system.errors.full_messages.join(', ')}"
                raise ActiveRecord::Rollback
              end
            end
          end
        end
        
        summary = ["Created #{systems_count} systems."]
        if duplicates.any?
          summary << "Ignored #{duplicates.size} duplicate #{'location'.pluralize(duplicates.size)}: #{duplicates.join(', ')}."
        end
        
        if errors.any?
          flash[:alert] = "#{summary.join(' ')} Errors encountered: #{errors.join('; ')}"
        else
          flash[:notice] = summary.join(' ')
        end
        
        redirect_to systems_path(sector_id: @sector.id)
      else
        flash[:alert] = "Please upload a valid .xlsx or .csv file."
        redirect_to bulk_upload_systems_path(sector_id: @sector.id)
      end
    else
      redirect_back_or_to systems_path(sector_id: params[:sector_id]), alert: "You do not have permission to edit systems."
    end
  end

  def show
    @system = SectorModel::System.select('systems.*, factions.name as faction_name, factions.description as faction_description').joins('left join factions on factions.name = systems.allegiance').find(params[:id])
    @sector = @system.sector
    unless can_view_systems?(@sector, current_user)
      redirect_back_or_to sector_path(@sector), alert: "You do not have permission to view systems for this sector."
    end
    @system_notes = visible_system_notes(@system, current_user)
  end

  def new
    @sector = SectorModel::Sector.find(params[:sector_model_system][:sector_id])
    @factions = SectorModel::Faction.where(sector_id: @sector.id)
    @page_libs = [:color_picker]
    
    if can_edit_systems?(@sector, current_user)
      @system = SectorModel::System.new
      @system.uwp = ""
      @system.pbg = 000
      @system.base = ""
      @system.notes = ""
      @system.ring = ""
    else
      redirect_back_or_to systems_path(sector_id: @sector.id), alert: "You do not have permission to edit systems."
    end
    
  end

  def create
    @sector = SectorModel::Sector.find(params[:sector_model_system][:sector_id])
    @factions = SectorModel::Faction.where(sector_id: @sector.id)
    
    if can_edit_systems?(@sector, current_user)
      @system = SectorModel::System.new(params.require(:sector_model_system).permit(:sector_id, :name, :location, :base, :ring, :allegiance, :created_at, :updated_at))
      @system.sector = @sector
      @system.uwp = combine_uwp_params(params[:sector_model_system])
      @system.notes = combine_note_params(params[:sector_model_system])
      @system.pbg = combine_pbg_params(params[:sector_model_system])
  
      if @system.save
        redirect_to system_path(@system.id)
      else
        render 'new'
      end
      
    else
      redirect_back_or_to systems_path(sector_id: @sector.id), alert: "You do not have permission to edit systems."
    end
    
  end

  def edit
    @system = SectorModel::System.find(params[:id])
    @sector = SectorModel::Sector.find(@system.sector_id)
    @factions = SectorModel::Faction.where(sector_id: @sector.id)
    @page_libs = [:color_picker]

    unless can_edit_systems?(@sector, current_user)
      redirect_back_or_to systems_path(sector_id: @system.sector_id), alert: "You do not have permission to edit systems."
    end
  end

  def update
    @system = SectorModel::System.find(params[:id])
    @sector = SectorModel::Sector.find(@system.sector_id)
    @factions = SectorModel::Faction.where(sector_id: @sector.id)
    
    if can_edit_systems?(@sector, current_user)
      @system.uwp = combine_uwp_params(params[:sector_model_system])
      @system.notes = combine_note_params(params[:sector_model_system])
      @system.pbg = combine_pbg_params(params[:sector_model_system])
  
      if @system.update(system_params)
        redirect_to system_path(@system.id)
      else
        render 'edit'
      end
    else
      redirect_back_or_to systems_path(sector_id: @system.sector_id), alert: "You do not have permission to edit systems."
    end
  end

  def destroy
    @system = SectorModel::System.find(params[:id])
    @sector = SectorModel::Sector.find(@system.sector_id)
    
    if can_edit_systems?(@sector, current_user)
      @system.destroy
      redirect_to systems_path(sector_id: @sector.id)
    else
      redirect_back_or_to systems_path(sector_id: @system.sector_id), alert: "You do not have permission to edit systems."
    end
    
  end

  private

  def system_params
    params.require(:sector_model_system).permit(:sector_id, :name, :location, :uwp, :base, :notes, :ring, :pbg, :allegiance, :created_at, :updated_at)
  end
  
end
