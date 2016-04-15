class EmployeeSearchDecorator < Draper::Decorator
  delegate :current_page, :total_pages, :limit_value, :entry_name, :total_count, :offset_value, :last_page?
  delegate_all

  def sort_link_for(title, attribute)
    helpers.link_to(
      title,
      context.organisation_path(helpers.organisation, path_options(attribute)),
      remote: true, class: link_class(attribute))
  end

  def path_options(attribute)
    {
      order: attribute
    }.tap do |h|
      h[:reverse] = 1 if order == attribute && reverse == 0
    end
  end

  def link_class(attribute)
    [].tap do |a|
      a << 'active' if attribute == order
      a << 'reverse' if attribute == order && reverse == 0
    end
  end
end
