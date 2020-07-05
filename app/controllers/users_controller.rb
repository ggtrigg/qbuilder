class UsersController < ApplicationController

  before_action :require_admin

  def index
    @users = User.all
  end

  def become
    return unless current_user.admin?
    bypass_sign_in(User.find(params[:id]))
    redirect_to root_url # or user_root_url
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def require_admin
    redirect_to root_path unless current_user.try(:admin?)
  end
end
