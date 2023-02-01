class ApplicationController < ActionController::Base
    before_action :authenticate_user!
    
  def check_admin
    if !current_user.admin?
      redirect_to root_path
    end
  end
  
end
