class Sector::SectorsController < ApplicationController
  before_action :check_member, only: [:new, :edit, :update, :destroy]
   
  def index
    @sectors = SectorModel::Sector.all
  end

  def show
    @sector = SectorModel::Sector.find(params[:id])
  end

  def new
    @sector = SectorModel::Sector.new
  end

  def create
    @sector = SectorModel::Sector.new(sector_params)

    if @sector.save
      redirect_to sector_path(@sector.id)
    else
      render 'new'
    end
  end

  def edit
    @sector = SectorModel::Sector.find(params[:id])
    
    unless @sector.author == current_user.email
      redirect_to sectors_path
    end
  end

  def update
    @sector = SectorModel::Sector.find(params[:id])
    
    if @sector.author == current_user.email
      if @sector.update(sector_params)
        redirect_to sector_path(@sector.id)
      else
        render 'edit'
      end
    else
      redirect_to sectors_path
    end
    
  end

  def destroy
    @sector = SectorModel::Sector.find(params[:id])
    
    if @sector.author == current_user.email
      @sector.destroy
    else
      redirect_to sectors_path
    end
    
    redirect_to sectors_path
  end

  private

  def sector_params
    params.require(:sector_model_sector).permit(:author, :name, :public_view, :created_at, :updated_at)
  end
  
end
