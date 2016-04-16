class OrganisationsController < ApplicationController
  skip_before_action :check_for_org, only: [:new, :create]

  def index
    @organisations = current_user.organisations.page(page)
  end

  def new
  end

  def create
    @organisation = current_user.organisations.create(org_params)
    if @organisation.valid?
      redirect_to new_organisation_employee_path(@organisation)
    else
      render :new
    end
  end

  def edit
  end

  def update
    organisation.update_attributes(org_params)
    if organisation.valid?
      redirect_to organisation_path(organisation)
    else
      render :edit
    end
  end

  def show
    params[:display] ||= 'table'
    case params[:display]
    when 'table'
      @search = EmployeeSearch.new(params.permit EmployeeSearch.allowed_params).decorate context: self
    when 'graph'
      @graph = OrganisationGraph.new organisation.employees, context: self
    end
  end

  private

  def org_params
    params.require(:organisation).permit(:name, :url, allowed_domains: [])
  end
end
