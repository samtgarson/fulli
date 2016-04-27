class EmployeeSearchDecorator < Draper::Decorator
  delegate_all

  def results
    EmployeesDecorator.decorate object.results, context: context
  end

  def sort_link_for(title, attribute)
    helpers.link_to(
      title,
      context.organisation_path(helpers.organisation, path_options(attribute)),
      remote: true, class: link_class(attribute))
  end

  def path_options(attribute)
    context.params.permit(object.class.allowed_params)
    .tap do |h|
      h[:order] = attribute
      h[:reverse] = order == attribute && reverse == 0 ? 1 : 0
      h[:format] = :js
    end
  end

  def link_class(attribute)
    return 'disabled' if skill.present?
    [].tap do |a|
      a << 'active' if attribute == order
      a << 'reverse' if attribute == order && reverse == 0
    end
  end
end
