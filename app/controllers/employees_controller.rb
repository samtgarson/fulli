class EmployeesController < ApplicationController
  def new
    @employee = Employee.new(organisation: organisation).decorate context: self
  end

  def create
    @employee = organisation.employees.create(employee_params).decorate context: self
    if @employee.valid?
      redirect_to organisation_path(organisation)
    else
      render :new
    end
  end

  def show
    redirect_to edit_organisation_employee_path(organisation, params[:id])
  end

  def edit
    @employee = Employee.find(params[:id]).decorate context: self
  end

  def update
    @employee = Employee.friendly.find(params[:id]).decorate context: self
    @employee.update_attributes(employee_params)

    if @employee.valid?
      flash[:notice] = "#{@employee.name} successfully updated."
      redirect_to organisation_path(organisation)
    else
      render :edit
    end
  end

  private

  def employee_params
    params.require(:employee).permit(:name, :title, :date_joined, :avatar, :parent_id)
  end
end
