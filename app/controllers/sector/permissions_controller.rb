class Sector::PermissionsController < ApplicationController
  before_action :set_sector

  def index
    @permissions = @sector.sector_permissions.includes(:user)
  end

  def new
    @permission = @sector.sector_permissions.new
    @users = User.where.not(id: @sector.permitted_users.pluck(:id)).where.not(email: @sector.author)
  end

  def create
    @permission = @sector.sector_permissions.new(permission_params)
    if @permission.save
      redirect_to sector_permissions_path(@sector), notice: 'Permission added successfully.'
    else
      @users = User.where.not(id: @sector.permitted_users.pluck(:id)).where.not(email: @sector.author)
      render :new
    end
  end

  def edit
    @permission = @sector.sector_permissions.find(params[:id])
  end

  def update
    @permission = @sector.sector_permissions.find(params[:id])
    if @permission.update(permission_params)
      redirect_to sector_permissions_path(@sector), notice: 'Permission updated successfully.'
    else
      render :edit
    end
  end

  def destroy
    @permission = @sector.sector_permissions.find(params[:id])
    @permission.destroy
    redirect_to sector_permissions_path(@sector), notice: 'Permission removed successfully.'
  end

  private

  def set_sector
    @sector = SectorModel::Sector.find(params[:sector_id])
    unless @sector.author == current_user.email || current_user.admin?
      redirect_back_or_to sectors_path, alert: 'You do not have permission to manage permissions for this sector.'
    end
  end

  def permission_params
    params.require(:sector_permission).permit(:user_id, :can_view_sector, :can_edit_sector, :can_view_factions, :can_edit_factions, :can_view_systems, :can_edit_systems, :can_view_system_notes, :can_edit_system_notes)
  end
end
