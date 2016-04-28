class @BasicTags extends Listener
  @registerListener 'select.basic-tags'
    
  instantiate: =>
    @el.selectize(@options.selectize)

  _defaultOptions: =>
    selectize:
      create: true
      persist: false
      selectOnTab: true
      copyClassesToDropdown: false
      plugins: ['remove_button']

$ =>
  $('.edit_employee').on('cocoon:after-insert', => 
    BasicTags.bindSelf()
    StarRating.bindSelf()
    Tabs.instances[0].updateHeight()
  ).on('cocoon:after-remove', =>
    Tabs.instances[0].updateHeight()
  )
