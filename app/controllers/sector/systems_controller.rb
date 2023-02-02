class Sector::SystemsController < ApplicationController
  before_action :check_admin, only: [:new, :edit, :update, :destroy]
  include Shared::SystemMapping
  include Sector::SystemsHelper
  
  def index
    @system = SectorModel::System.where("sector_id = ?", params[:sector_id])
  end

  def show
    @system = SectorModel::System.find(params[:id])
  end

  def new
    @sector = SectorModel::Sector.find(params[:sector_model_system][:sector_id])
    @system = SectorModel::System.new
  end

  def create
    @sector = SectorModel::Sector.find(params[:sector_model_system][:sector_id])
    @system = SectorModel::System.new(params.require(:sector_model_system).permit(:sector_id, :name, :location, :base, :ring, :allegiance))
    @system.sector = @sector
    @system.uwp = combine_uwp_params(params[:sector_model_system])
    @system.notes = combine_note_params(params[:sector_model_system])
    @system.pbg = combine_pbg_params(params[:sector_model_system][:pop_base], params[:sector_model_system])

    if @system.save
      redirect_to system_path(@system.id)
    else
      render 'new'
    end

  end

  def edit
    @system = SectorModel::System.find(params[:id])
  end

  def update
    @system = SectorModel::System.find(params[:id])
    @system.uwp = combine_uwp_params(params[:sector_model_system])
    @system.notes = combine_note_params(params[:sector_model_system])
    @system.pbg = combine_pbg_params(@system.pbg, params[:sector_model_system])

    if @system.update(system_params)
      redirect_to system_path(@system.id)
    else
      render 'edit'
    end

  end

  def destroy
    @system = SectorModel::System.find(params[:id])
    @system.destroy

    redirect_to systems_path(sector_id: params[:sector_id])
  end

  private

  def system_params
    params.require(:sector_model_system).permit(:sector_id, :name, :location, :uwp, :base, :notes, :ring, :pdg, :allegiance)
  end
  
end
