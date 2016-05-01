class EmployeeDecorator < Draper::Decorator
  delegate :current_page, :total_pages, :limit_value, :entry_name, :total_count, :offset_value, :last_page?
  delegate_all

  def rating_for_skill(name)
    employee_skills.joins(:skill).find_by(skills: { name: name }).rating
  end

  def parent_selector_options
    {
      class: 'humans',
      data: {
        options: {
          selectize: {
            options: helpers.organisation.top_employees.all_except(id).as_json,
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

  def for_graph
    {
      id: id,
      label: name.upcase.chars.join(' '),
      image: avatar.url,
      url: context.organisation_employee_url(helpers.organisation, object)
    }
  end
end
