class @BasicTags extends Listener
  Listener.register @, 'select.basic-tags'
    
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
  $('.edit_skill_set').on('cocoon:after-insert', => BasicTags.bindSelf())
