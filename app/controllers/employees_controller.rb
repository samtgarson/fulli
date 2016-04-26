class EmployeesController < ApplicationController
  def new
    back organisation.name, organisation_path(organisation)
    @employee = Employee.new(organisation: organisation).decorate context: self
  end

  def create
    @employee = organisation.employees.create(employee_params).decorate context: self
    if @employee.valid?
      redirect_to organisation_path(organisation)
    else
      back organisation.name, organisation_path(organisation)
      render :new
    end
  end

  def show
    redirect_to edit_organisation_employee_path(organisation, params[:id])
  end

  def edit
    back organisation.name, organisation_path(organisation)
    @employee = Employee.find(params[:id]).decorate context: self
  end

  def update
    back organisation.name, organisation_path(organisation)
    @employee = Employee.friendly.find(params[:id]).decorate context: self
    @employee.update_attributes(employee_params)

    flash[:notice] = "#{@employee.name} successfully updated." if @employee.valid?
    render :edit
  end

  def destroy
    @employee = Employee.friendly.find(params[:id])
    if @employee.destroy
      redirect_to organisation_path(organisation)
    else
      render :edit
    end
  end

  private

  def employee_params
    params.require(:employee).permit(:name, :title, :date_joined, :avatar, :parent_id, employee_skills_attributes: [:skill, :rating, :id, :_destroy], experience_list: [], interest_list: [], project_list: [])
  end
end
