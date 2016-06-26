class UserDecorator < Draper::Decorator
  delegate_all

  def parent_selector_options
    possible_parents = helpers.organisation.top_employees.all_except(id)
    {
      class: 'humans',
      placeholder: possible_parents.any? ? helpers.t('.choose_manager') : helpers.t('.no_managers'),
      data: {
        options: {
          selectize: {
            options: possible_parents.as_json,
            items: [(parent.id if parent)]
          },
          ajax: {
            except: id,
            action: context.organisation_path(helpers.organisation),
            org_id: helpers.organisation.id
          }
        }
      }
    }
  end

  def role_form
    case role
    when 'owner'
      'Owner'
    when 'admin'
      [].tap do |a|
        a << helpers.content_tag(:span, 'Admin')
        a << promote_form(nil, 'Demote from Admin') if helpers.current_user.owner?
      end.join(' ').html_safe
    else
      promote_form(:admin, 'Make Admin') if helpers.current_user.admin?
    end
  end

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

  def for_graph
    {
      id: id,
      label: name.upcase.chars.join(' '),
      image: avatar.url
    }
  end

  private

  def promote_form(new_role, label)
    helpers.simple_form_for object, remote: true do |f|
      [
        f.hidden_field(:role, value: new_role),
        f.button(:button, label, class: 'hover btn secondary inline')
      ].join(' ').html_safe
    end
  end
end
