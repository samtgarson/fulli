class InvitationsController < Devise::InvitationsController

  def create
    super do |u|
      u.organisations << Organisation.friendly.find(params[:organisation_id])
    end
  end

end
