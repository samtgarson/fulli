class AssociationController < ApplicationController
  def update
    only_admins!
    if association.update_attributes association_params
      flash[:notice] = "#{association.user.name} has been updated successfully."
    else
      flash[:alert] = "Something went wrong. Please try again or drop us an email."
    end
    redirect_to edit_organisation_path(organisation)
  end

  protected

  def association
    @association ||= Association.find(params[:id])
  end

  def association_params
    params.require(:association).permit(:role)
  end
end
