class Sector::SystemNotesController < ApplicationController
  before_action :check_member, only: [:new, :edit, :update, :destroy]
   
  def index
    @system = SectorModel::System.find(params[:system_id])
    @sector = @system.sector
    
    @system_notes = visible_system_notes(@system, current_user)
    
    if can_view_systems?(@sector, current_user)
      if params[:partial] == "yes"
        render partial: 'sector/system_notes/system_notes'
      end
    else
      redirect_back_or_to system_path(@system), alert: "You do not have permission to view this system."
    end
  end

  def new
    @system = SectorModel::System.find(params[:system_id])
    @sector = @system.sector
    
    if can_edit_system_notes?(@sector, current_user)
      @system_note = SectorModel::SystemNote.new
      respond_to do |format|
        format.html
        format.js
      end
    else
      redirect_back_or_to system_path(@system), alert: "You do not have permission to edit system notes."
    end
  end

  def create
    @system = SectorModel::System.find(params[:system_id])
    @sector = @system.sector

    if can_edit_system_notes?(@sector, current_user)
      @system_note = SectorModel::SystemNote.new(system_note_params)
      @system_note.system_id = @system.id
      if @system_note.save
        respond_to do |format|
          format.html { redirect_to system_path(@system) }
          format.js { head :no_content }
        end
      else
        respond_to do |format|
          format.html { render 'new' }
          format.js { render partial: 'form', locals: { errors: @system_note.errors }, status: :unprocessable_entity }
        end
      end
    else
      redirect_back_or_to system_path(@system), alert: "You do not have permission to edit system notes."
    end
  end

  def edit
    @system_note = SectorModel::SystemNote.find(params[:id])
    @system = SectorModel::System.find(params[:system_id])
    @sector = @system.sector
    
    unless can_edit_system_notes?(@sector, current_user) && (@system_note.author == current_user.email || @sector.author == current_user.email || current_user.admin?)
      redirect_back_or_to system_path(@system.id), alert: "You do not have permission to edit this system note."
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    @system_note = SectorModel::SystemNote.find(params[:id])
    @system = SectorModel::System.find(params[:system_id])
    @sector = @system.sector
    
    if can_edit_system_notes?(@sector, current_user) && (@system_note.author == current_user.email || @sector.author == current_user.email || current_user.admin?)
      if @system_note.update(system_note_params)
        respond_to do |format|
          format.html { redirect_to system_path(@system) }
          format.js { head :no_content }
        end
      else
        respond_to do |format|
          format.html { render 'edit' }
          format.js { render partial: 'form', locals: { errors: @system_note.errors }, status: :unprocessable_entity }
        end
      end
    else
      redirect_back_or_to system_path(@system.id), alert: "You do not have permission to edit this system note."
    end
    
  end

  def destroy
    @system_note = SectorModel::SystemNote.find(params[:id])
    @system = SectorModel::System.find(params[:system_id])
    @sector = @system.sector
    
    if can_edit_system_notes?(@sector, current_user) && (@system_note.author == current_user.email || @sector.author == current_user.email || current_user.admin?)
      @system_note.destroy
    else
      redirect_back_or_to system_path(@system.id), alert: "You do not have permission to delete this system note." and return
    end
    
    redirect_to system_path(@system.id)
  end

  private

  def system_note_params
    params.require(:sector_model_system_note).permit(:system_id, :author, :content, :public_view, :created_at, :updated_at)
  end
  
end
