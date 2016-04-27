class OrganisationsController < ApplicationController
  skip_before_action :check_access_to_org, only: [:new, :create, :index]
  skip_before_action :set_admin, only: :index

  def index
    @organisations = current_user.organisations.page(page)
  end

  def new
    back 'Organisations', organisations_path
  end

  def create
    @organisation = current_user.organisations.create(org_params)
    if @organisation.valid?
      redirect_to new_organisation_employee_path(@organisation)
    else
      back 'Organisations', organisations_path
      render :new
    end
  end

  def edit
    only_admins!
    back organisation.name, organisation_path(organisation)
  end

  def update
    organisation.update_attributes(org_params)
    if organisation.valid?
      redirect_to organisation_path(organisation)
    else
      back organisation.name, organisation_path(organisation)
      render :edit
    end
  end

  def show
    back 'Organisations', organisations_path
    params[:display] ||= 'table'
    case params[:display]
    when 'table'
      @search = EmployeeSearch.new(params.permit EmployeeSearch.allowed_params).decorate context: self
    when 'graph'
      @graph = OrganisationGraph.new organisation.employees, context: self
    end
  end

  def remove_user
    @id = selected_user.id
    organisation.users.delete(selected_user)
    selected_user.organisations.delete(organisation)
    render 'users/destroy'
  end

  def destroy
    if organisation.destroy
      redirect_to current_user.organisations.any? ? organisations_path : new_organisation_path
    else
      render :edit
    end
  end

  private

  def selected_user
    User.friendly.find(params[:user_id])
  end

  def org_params
    params.require(:organisation).permit(:name, :url, :allowed_domains)
  end
end
