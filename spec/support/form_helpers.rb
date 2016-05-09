module FormHelpers
  def select_date(date, options = {})
    field = options[:from]
    select date.year.to_s, from: "#{field}_1i"
    select Date::MONTHNAMES[date.month], from: "#{field}_2i"
    select date.day.to_s, from: "#{field}_3i"
  end

  def add_tags_to_selectize(selector, options = {})
    fail 'Array expected' unless options[:with].is_a?(Array)
    options[:with].each do |tag|
      if options[:create]
        page.execute_script("$('#{selector}').data('selectize').createItem('#{tag}')")
      else
        page.execute_script("$('#{selector}').data('selectize').addItem('#{tag}')")
      end
    end
    page.execute_script("$('#{selector}').data('selectize').blur()")
  end

  def select_value_of(selector)
    page.evaluate_script("$('#{selector}').data('selectize').getValue()")
  end
end
