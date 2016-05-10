class UserDecorator < Draper::Decorator
  delegate_all

  def role_form
    case role
    when 'owner'
      'Owner'
    when 'admin'
      [].tap do |a|
        a << helpers.content_tag(:span, 'Admin')
        a << promote_form(nil, 'Demote from Admin') if helpers.current_user.owner_of?(helpers.organisation)
      end.join(' ').html_safe
    else
      promote_form(:admin, 'Make Admin') if helpers.current_user.admin_of?(helpers.organisation)
    end
  end

  def association
    associations.find_by(organisation_id: helpers.organisation.id)
  end

  delegate :role, to: :association

  def owner?
    role == 'owner'
  end

  def current?
    object == helpers.current_user
  end

  def remove_link
    if user.pending_invite?
      helpers.button_to context.user_path(object), method: :delete do
        helpers.content_tag :span, 'b', class: 'icon'
      end
    else
      helpers.button_to context.remove_user_organisation_path(user_id: slug), method: :delete do
        helpers.content_tag :span, 'b', class: 'icon'
      end
    end
  end

  private

  def promote_form(new_role, label)
    helpers.simple_form_for [helpers.organisation, association] do |f|
      [
        f.hidden_field(:role, value: new_role),
        f.button(:button, label, class: 'hover btn secondary inline')
      ].join(' ').html_safe
    end
  end
end
