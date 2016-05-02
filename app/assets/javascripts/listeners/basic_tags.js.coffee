class Listeners.BasicTags extends Listener
  @listenerSelector: 'select.basic-tags'
    
  instantiate: =>
    @el.selectize(@options.selectize)

  _defaultOptions: =>
    selectize:
      create: true
      persist: false
      selectOnTab: true
      copyClassesToDropdown: false
      plugins: ['remove_button']
      dropdownParent: 'body'

$ =>
  $('.edit_employee').on('cocoon:after-insert', => 
    Listeners.BasicTags.bindSelf()
    Listeners.StarRating.bindSelf()
    Listeners.Tabs.instances[0].updateHeight()
  ).on('cocoon:after-remove', =>
    Listeners.Tabs.instances[0].updateHeight()
  )
