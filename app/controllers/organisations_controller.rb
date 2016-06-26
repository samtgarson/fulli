class OrganisationsController < ApplicationController
  skip_before_action :set_admin, only: [:new, :create]
  skip_before_action :check_org, only: [:new, :create]
  skip_before_action :check_attributes, only: [:new, :create]
  before_action :only_admins!, except: [:new, :create, :show]

  def new
  end

  def create
    @organisation = Organisation.create(org_params)
    if @organisation.valid?
      current_user.update_attributes role: 'owner', organisation: @organisation
      redirect_to organisation_path(@organisation)
    else
      render :new
    end
  end

  def edit
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
    params[:display] ||= 'table'
    case params[:display]
    when 'table'
      record_event
      @search = UserSearch.new(params.merge(id: organisation.id).permit UserSearch.allowed_params).decorate context: self
    when 'graph'
      @graph = OrganisationGraph.new organisation.users, context: self
    end
  end

  def remove_user
    @id = selected_user.id
    selected_user.update_attributes organisation_id: nil, role: nil

    respond_to do |format|
      format.js { render 'users/destroy' }
      format.html { redirect_to selected_user == current_user ? organisations_path : edit_organisation_path(organisation) }
    end
  end

  def transfer
    from = organisation.users.find_by role: 'owner'
    to = organisation.users.object.find params[:user_id]
    from.update_attributes(role: 'admin')
    to.update_attributes(role: 'owner')

    flash[:notice] = "#{organisation.name} transferred successfully."
    redirect_to edit_organisation_path(organisation), status: 303
  end

  def destroy
    if organisation.destroy
      redirect_to current_user.organisations.any? ? organisations_path : new_organisation_path
    else
      render :edit
    end
  end

  private

  def record_event
    Heap.event('Perform filter', current_user.email, clean_search_params)
  end

  def clean_search_params
    params.permit(:query, experience: [],
                          projects: [],
                          interests: [],
                          skills: []).symbolize_keys.each_with_object({}) { |(k, v), sum| sum[k] = v.to_s }
  end

  def selected_user
    @selected_user ||= User.friendly.find(params[:user_id])
  end

  def org_params
    params.require(:organisation).permit(:name, :url, :allowed_domains)
  end
end
