module FormHelpers
  def select_date(field, options = {})
    date = options[:with]
    select date.year.to_s, :from => "#{field}_1i"
    select Date::MONTHNAMES[date.month], :from => "#{field}_2i"
    select date.day.to_s, :from => "#{field}_3i"  
  end

  def add_tags_to_selectize(parent_selector, with:)
    fail "Array expected" unless with.is_a?(Array)
    selector = "#{parent_selector} + .selectize-control .selectize-input input".to_json.html_safe
    with.each do |tag|
      tag = tag.to_json.html_safe
      # type the data in the partially hidden placeholder
      page.execute_script("$(#{selector}).val(#{tag})")
      # make the selectize dropdown appear
      page.execute_script("$(#{selector}).keyup()")
      # click somewhere else to hide the dropdown and add the tag for good
      page.execute_script("$('body').mousedown()")
    end
  end
end
