class UserDecorator < Draper::Decorator
  delegate_all

  def remove_link
    if user.has_pending_invite?
      # context.remove_user_invitation_path(invitation_token: invitation_token, user_id: id)
      helpers.link_to context.user_path(object), method: :delete, remote: true do
        helpers.content_tag :span, 'b', class: 'icon'
      end
    else
      helpers.link_to context.remove_user_organisation_path(user_id: slug), method: :delete, remote: true do
        helpers.content_tag :span, 'b', class: 'icon'
      end
    end
  end
end
