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
            action: context.organisation_employees_path,
            org_id: helpers.organisation.id
          }
        }
      }
    }
  end
end
