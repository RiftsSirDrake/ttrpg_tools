class Sector::SectorsController < ApplicationController
  before_action :check_member, only: [:new, :edit, :update, :destroy]
   
  def index
    @sectors = SectorModel::Sector.left_outer_joins(:sector_permissions)
                                  .where("sectors.public_view = '1' OR sectors.author = ? OR sector_permissions.user_id = ?", current_user.email, current_user.id)
                                  .distinct
    if current_user.admin?
      @sectors = SectorModel::Sector.all
    end
  end

  def show
    @sector = SectorModel::Sector.find(params[:id])
    unless can_view_sector?(@sector, current_user)
      redirect_back_or_to sectors_path, alert: "You do not have permission to view this sector."
    end
  end

  def new
    @sector = SectorModel::Sector.new
  end

  def create
    @sector = SectorModel::Sector.new(sector_params)

    if @sector.save
      redirect_to sectors_path
    else
      render 'new'
    end
  end

  def edit
    @sector = SectorModel::Sector.find(params[:id])
    
    unless can_edit_sector?(@sector, current_user)
      redirect_back_or_to sectors_path, alert: "You do not have permission to edit this sector."
    end
  end

  def update
    @sector = SectorModel::Sector.find(params[:id])
    
    if can_edit_sector?(@sector, current_user)
      if @sector.update(sector_params)
        redirect_to sectors_path
      else
        render 'edit'
      end
    else
      redirect_back_or_to sectors_path, alert: "You do not have permission to edit this sector."
    end
    
  end

  def destroy
    @sector = SectorModel::Sector.find(params[:id])
    
    if @sector.author == current_user.email || current_user.admin?
      @sector.destroy
    else
      redirect_back_or_to sectors_path, alert: "Only the author can delete this sector." and return
    end
    
    redirect_to sectors_path
  end

  private

  def sector_params
    params.require(:sector_model_sector).permit(:author, :name, :public_view, :created_at, :updated_at)
  end
  
end
