class InvitationsController < Devise::InvitationsController
  def create
    if existing_user
      existing_user.update_attributes(organisation: organisation)
      redirect_to(edit_organisation_path(organisation)) and return
    else
      super { |u| u.update_attributes(organisation: organisation) }
    end
  end

  def existing_user
    @existing_user ||= User.find_by(email: invite_params[:email])
  end

  def after_invite_path_for(_user)
    edit_organisation_path(organisation)
  end
end
