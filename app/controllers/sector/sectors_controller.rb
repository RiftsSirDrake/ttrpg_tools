class Sector::SectorsController < ApplicationController
  before_action :check_member, only: [:new, :edit, :update, :destroy]
  before_action :presets, only: [:new, :edit, :create, :update]
   
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
    gon.hex_color = "#f8f9fa"
    gon.border_width = 4
    gon.border_opacity = 0.5
    gon.background_image = nil
    gon.show_grid = true
    gon.grid_opacity = 0.1
    gon.background_images = Dir.glob(Rails.root.join('app', 'assets', 'images', 'backgrounds', '*.svg')).each_with_object({}) do |f, hash|
      filename = File.basename(f)
      hash[filename] = ActionController::Base.helpers.image_path("backgrounds/#{filename}")
    end
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

    gon.hex_color = @sector.hex_color.presence || "#f8f9fa"
    gon.border_width = @sector.border_width.presence || 4
    gon.border_opacity = @sector.border_opacity.presence || 0.5
    gon.background_image = @sector.background_image.presence
    gon.show_grid = @sector.show_grid
    gon.grid_opacity = @sector.grid_opacity.presence || 0.1
    gon.background_images = Dir.glob(Rails.root.join('app', 'assets', 'images', 'backgrounds', '*.svg')).each_with_object({}) do |f, hash|
      filename = File.basename(f)
      hash[filename] = ActionController::Base.helpers.image_path("backgrounds/#{filename}")
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

  def presets
    @page_libs = [:hexmap]
    
    # Sample data for hexmap preview
    @preview_data = {
      "0" => { n: "System A", q: 1, r: 1, hex_loc: "0101", allegiance: "Faction 1", colour: "#ff5733" },
      "1" => { n: "System B", q: 1, r: 2, hex_loc: "0102", allegiance: "Faction 1", colour: "#ff5733" },
      "2" => { n: "System C", q: 2, r: 1, hex_loc: "0201", allegiance: "Faction 2", colour: "#33ff57" },
      "3" => { n: "System D", q: 2, r: 2, hex_loc: "0202", allegiance: "Faction 2", colour: "#33ff57" }
    }
    gon.data = @preview_data
  end

  def sector_params
    params.require(:sector_model_sector).permit(:author, :name, :public_view, :hex_color, :border_width, :border_opacity, :background_image, :show_grid, :grid_opacity, :created_at, :updated_at)
  end

  # TODO: Add in ability to export an entire sector, its systems, notes, factions, and sector settings.
  #   This should be done in a way that it could later be reimported to recreate that sector.

end
