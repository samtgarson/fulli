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
    @employees = organisation.employees.order(:name).page(page)
  end

  private

  def organisation
    if params[:id]
      @organisation ||= Organisation.friendly.find(params[:id])
    else
      @organisation ||= Organisation.new
    end
  end
  helper_method :organisation

  def org_params
    params.require(:organisation).permit(:name, :url, allowed_domains: [])
  end
end
