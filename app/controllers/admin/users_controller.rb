class Admin::UsersController < Admin::BaseController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def reset_password
    @user = User.find(params[:id])
    new_password = Devise.friendly_token.first(8)
    if @user.update(password: new_password, password_confirmation: new_password)
      redirect_to admin_user_path(@user), notice: "Password reset successfully. New password is: #{new_password}"
    else
      redirect_to admin_user_path(@user), alert: "Failed to reset password."
    end
  end

  private

  def user_params
    params.require(:user).permit(:role, :email)
  end
end
