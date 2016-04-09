class EmployeesController < ApplicationController

  def new
    @employee = Employee.new(organisation: organisation)
  end

  def create
    @employee = organisation.employees.create(employee_params)
    if @employee.valid?
      redirect_to organisation_path(organisation)
    else
      render :new
    end
  end

  def show
    @employee = Employee.find(params[:id])
  end

  private

  def organisation
    @organisation ||= Organisation.find_by slug: params[:organisation_id]
  end
  helper_method :organisation

  def employee_params
    params.require(:employee).permit(:name, :title, :date_joined, :avatar)
  end
end
