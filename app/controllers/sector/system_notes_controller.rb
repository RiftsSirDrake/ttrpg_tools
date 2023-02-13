class Sector::SystemNotesController < ApplicationController
  before_action :check_member, only: [:new, :edit, :update, :destroy]
   
  def index
    @system_notes = SectorModel::SystemNote.where(system_id: params[:system_id])
    @system = SectorModel::System.find(params[:system_id])
    
    if params[:partial] == "yes"
      render partial: 'sector/system_notes/system_notes'
    end
    
  end

  def new
    @system_note = SectorModel::SystemNote.new
    @system = SectorModel::System.find(params[:sector_model_system_note][:system_id])
    
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @system_note = SectorModel::SystemNote.new(system_note_params)
    @system = SectorModel::System.find(params[:sector_model_system_note][:system_id])

    if @system_note.save
      respond_to do |format|
        format.html { redirect_to system_note_path(@system_note) }
        format.js
      end
    else
      respond_to do |format|
        format.html { render 'new' }
        format.js { render partial: 'form', locals: { errors: @system_note.errors } }
      end
    end
  end

  def edit
    @system_note = SectorModel::SystemNote.find(params[:id])
    @system = SectorModel::System.find(params[:sector_model_system_note][:system_id])
    
    unless @system_note.author == current_user.email
      redirect_to system_path(@system.id)
    end
  end

  def update
    @system_note = SectorModel::SystemNote.find(params[:id])
    @system = SectorModel::System.find(params[:sector_model_system_note][:system_id])
    
    if @system_note.author == current_user.email
      if @system_note.update(system_note_params)
        respond_to do |format|
          format.html { redirect_to system_note_path(@system_note) }
          format.js
        end
      else
        respond_to do |format|
          format.html { render 'edit' }
          format.js { render partial: 'form', locals: { errors: @system_note.errors } }
        end
      end
    else
      redirect_to system_path(@system.id)
    end
    
  end

  def destroy
    @system_note = SectorModel::SystemNote.find(params[:id])
    @system = SectorModel::System.find(params[:sector_model_system_note][:system_id])
    
    if @system_note.author == current_user.email
      @system_note.destroy
    else
      redirect_to system_path(@system.id)
    end
    
    redirect_to system_path(@system.id)
  end

  private

  def system_note_params
    params.require(:sector_model_system_note).permit(:system_id, :author, :content, :public_view, :created_at, :updated_at)
  end
  
end
