class SkillSetsController < ApplicationController
  
  def show
    redirect_to edit_organisation_employee_skill_set_path(organisation, employee)
  end

  def edit

  end

  def update
    success = skill_set.update_attributes(skill_set_params)
    if success
      flash[:notice] = "#{@employee.name} successfully updated."
      redirect_to organisation_employee_skill_set_path(organisation, employee)
    else
      render :edit
    end
  end

  private

  def employee
    @employee ||= Employee.friendly.find(params[:employee_id])
  end
  helper_method :employee

  def skill_set
    @skill_set ||= employee.skill_set || SkillSet.create(employee: employee)
  end
  helper_method :skill_set

  def skill_set_params
    params.require(:skill_set).permit(employee_skills_attributes: [:skill, :rating, :id, :_destroy])
  end
end
