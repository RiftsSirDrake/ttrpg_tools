class Sector::FactionsController < ApplicationController
  before_action :check_member, only: [:new, :edit, :update, :destroy]
  before_action :presets
   
  def index
    @sector = SectorModel::Sector.find(params[:sector_id])
    @factions = SectorModel::Faction.where("sector_id = ?", params[:sector_id])
  end

  def show
    @faction = SectorModel::Faction.find(params[:id])
    @sector = @faction.sector
  end

  def new
    @sector = SectorModel::Sector.find(params[:sector_id] || params.dig(:sector_model_faction, :sector_id))
    @faction = SectorModel::Faction.new
  end

  def create
    @sector = SectorModel::Sector.find(params[:sector_id] || params.dig(:sector_model_faction, :sector_id))
    @faction = SectorModel::Faction.new(faction_params)
    @faction.sector = @sector

    if @faction.save
      respond_to do |format|
        format.html { redirect_to factions_path(sector_id: @sector.id) }
        format.json { render json: @faction, status: :created }
      end
    else
      respond_to do |format|
        format.html { render 'new' }
        format.json { render json: @faction.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @sector = SectorModel::Sector.find(params[:sector_id] || params.dig(:sector_model_faction, :sector_id))
    @faction = SectorModel::Faction.find(params[:id])
    
    unless @sector.author == current_user.email
      redirect_to factions_path(sector_id: @sector.id)
    end
  end

  def update
    @sector = SectorModel::Sector.find(params[:sector_id] || params.dig(:sector_model_faction, :sector_id))
    @faction = SectorModel::Faction.find(params[:id])
    
    if @sector.author == current_user.email
      if @faction.update(faction_params)
        redirect_to factions_path(sector_id: @sector.id)
      else
        render 'edit'
      end
    else
      redirect_to factions_path(sector_id: @sector.id)
    end
    
  end

  def destroy
    @sector = SectorModel::Sector.find(params[:sector_id] || params[:sector_model_faction][:sector_id])
    @faction = SectorModel::Faction.find(params[:id])
    
    if @sector.author == current_user.email
      @faction.destroy
    else
      redirect_to factions_path(sector_id: @sector.id) and return
    end
    
    redirect_to factions_path(sector_id: @sector.id)
  end

  private

  def faction_params
    params.require(:sector_model_faction).permit(:sector_id, :name, :description, :color_code, :created_at, :updated_at)
  end

	def presets
		@page_libs = [:color_picker]
	end
	
end
