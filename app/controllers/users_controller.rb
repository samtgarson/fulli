class UsersController < ApplicationController
  skip_before_action :check_access_to_org, only: :destroy
  skip_before_action :set_admin, only: :destroy

  def destroy
    @id = user.id
    name = (user.destroy).name

    flash.now[:alert] = "#{name} removed successfully."

    respond_to do |format|
      format.js
      format.html { redirect_to request.referer }
    end
  end

  private

  def user
    User.find(params[:id])
  end
end
