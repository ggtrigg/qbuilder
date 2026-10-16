class UsersController < ApplicationController
  before_action :require_admin

  def index
    @users = User.select(:id, :email, :admin, :created_at, :confirmed_at)
  end

  def confirm_become
    @user = User.find(params[:id])
  end

  def become
    return unless current_user&.admin?
    @user = User.find(params[:id])
    AdminImpersonation.create!(admin: current_user, target_user: @user)
    bypass_sign_in(@user)
    redirect_to root_url
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@user) }
    end
  end

  private

  def require_admin
    redirect_to root_path unless current_user&.admin?
  end
end
