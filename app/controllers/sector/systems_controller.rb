class Sector::SystemsController < ApplicationController
  before_action :check_admin, only: [:new, :edit, :update, :destroy]
  

  def index
    @system = SectorModel::System.where("sector_id = ?", params[:sector_id])
  end

  def show
    @system = SectorModel::System.find(params[:id])
  end

  def new
    @system = SectorModel::System.new
    @system.sector_id = params[:sector_id]
  end

  def create
    @system = SectorModel::System.new(system_params)

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

    if @system.update(system_params)
      redirect_to system_path(@system.id)
    else
      render 'edit'
    end
  end

  def destroy
    @system = SectorModel::System.find(params[:id])
    @system.destroy

    redirect_to systems_path
  end

  private

  def system_params
    params.require(:system_model_sector).permit(:sector_id, :name, :location, :uwp, :base, :notes, :ring, :pdg, :allegiance)
  end
  
end
