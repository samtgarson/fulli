class InvitationsController < Devise::InvitationsController
  def create
    super do |u|
      u.organisations << organisation unless u.organisation_ids.include?(organisation.id)
      redirect_to(edit_organisation_path(organisation)) && return if already_exists?(u)
    end
  end

  def already_exists?(u)
    User.where(email: u.email).any?
  end

  def after_invite_path_for(_user)
    edit_organisation_path(organisation)
  end
end
