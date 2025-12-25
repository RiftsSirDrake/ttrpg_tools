class ApplicationController < ActionController::Base
    before_action :authenticate_user!
    include SectorPermissionsHelper
    
  def check_admin
    unless current_user.admin?
      redirect_back_or_to root_path, alert: "You do not have permission to access this page."
    end
  end

  def check_member
    unless current_user.member? || current_user.admin?
      redirect_back_or_to root_path, alert: "You must be a member or admin to perform this action."
    end
  end

  private

  def redirect_back_or_to(default, options = {})
    if request.referer.present? && request.referer != request.original_url
      redirect_to request.referer, options
    else
      redirect_to default, options
    end
  end
  
end
