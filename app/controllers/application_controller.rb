class ApplicationController < ActionController::Base
    before_action :authenticate_user!
    
  def check_admin
    unless current_user.admin?
      redirect_to root_path
    end
  end

  def check_member
    unless current_user.member? || current_user.admin?
      redirect_to root_path
    end
  end
  
end
