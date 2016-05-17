class UsersController < ApplicationController
  skip_before_action :check_attributes, only: [:edit, :update]
  skip_before_action :set_admin
  before_action :only_admins!, only: :destroy

  def edit
    redirect_to root_path and return if request.format.html? && selected_user != current_user
  end

  def update
    redirect_to root_path and return if request.format.html? && selected_user != current_user
    back organisation.name, organisation_path(organisation)
    first_time = selected_user.onboarded_at.nil?

    if selected_user.update_attributes(user_params)
      flash[:notice] = 'Your profile is successfully updated.'
    else
      flash[:alert] = 'Something went wrong. Please try again.'
    end

    if first_time
      redirect_to organisation_path(selected_user.organisation)
    else
      respond_to do |format|
        format.html { render :edit }
        format.js
      end
    end
  end

  def destroy
    @id = selected_user.id
    name = selected_user.destroy.name

    flash.now[:alert] = "#{name} removed successfully."

    respond_to do |format|
      format.js
      format.html { redirect_to request.referer }
    end
  end

  private

  def selected_user
    @selected_user ||= User.friendly.find(params[:id]).decorate(context: self)
  end

  def user_params
    params.require(:user).permit(:name, :title, :role, :date_joined, :onboarded_at, :avatar, :parent_id, employee_skills_attributes: [:skill, :rating, :id, :_destroy], experience_list: [], interest_list: [], project_list: [])
  end
end
