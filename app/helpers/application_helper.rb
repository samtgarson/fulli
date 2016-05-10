module ApplicationHelper
  def body_class
    [
      controller_name,
      action_name
    ].join ' '
  end

  def basic_tag_options(items)
    {
      collection: ActsAsTaggableOn::Tag.all.map(&:name),
      input_html: {
        multiple: true,
        class: 'basic-tags',
        data: {
          options: {
            selectize: {
              items: items
            }
          }
        }
      },
      wrapper_html: {
        class: 'select selectize-wrapper'
      }
    }
  end

  def filter_tag(key, options = {})
    content_tag :div, class: "#{options[:class]} selectize-wrapper input #{'disabled' if params[:display] == 'graph'}" do
      select_tag key, options_for_select(options[:options]),
        multiple: true,
        class: 'basic-tags',
        placeholder: t("simple_form.labels.employee.#{options[:placeholder]}"),
        disabled: (params[:display] == 'graph'),
        data: { options: {
          selectize: {
            items: [params[key]],
            create: false,
            closeAfterSelect: true,
            maxItems: options.fetch(:max_items, 1000)
          }
        } }
    end
  end
end
