class EmployeeDecorator < Draper::Decorator
  delegate_all

  def parent_selector_options
    {
      class: 'humans',
      data: {
        options: {
          selectize: {
            options: helpers.organisation.top_employees.all_except(id).as_json,
            items: [(parent && parent.id)]
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

  def for_graph
    {
      id: id,
      label: name.upcase.chars.join(' '),
      image: avatar.url,
      url: context.organisation_employee_url(helpers.organisation, object)
    }
  end

  private

  def max_depth
    Employee.maximum(:ancestry_depth)
  end
end
