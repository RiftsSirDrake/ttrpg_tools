class ProfilesController < ApplicationController
  def show
    @user = current_user
    @sectors = SectorModel::Sector.where(author: @user.email)
  end
end
