class OrganisationsController < ApplicationController
  skip_before_action :check_for_org, only: [:new, :create]

  def index
    @organisations = current_user.organisations
  end

  def new
    @organisation = Organisation.new
  end

  def create
    @organisation = current_user.organisations.create(org_params)
    if @organisation.valid?
      redirect_to new_organisation_employee_path(@organisation)
    else
      render :new
    end
  end

  private

  def organisation
    @organisation ||= Organisation.find_by slug: params[:id]
  end
  helper_method :organisation

  def org_params
    params.require(:organisation).permit(:name, :slug, allowed_domains: [])
  end
end
