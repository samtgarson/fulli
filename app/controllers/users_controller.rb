class UsersController < ApplicationController
  def destroy
    @id = user.id
    user.destroy
  end

  private

  def user
    User.find(params[:id])
  end  
end
