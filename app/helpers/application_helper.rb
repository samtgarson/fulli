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
end
