class @BasicTags extends Listener
  Listener.register @, 'basic-tags'
    
  instantiate: =>
    @el.selectize(@options.selectize)

  _defaultOptions: =>
    selectize:
      create: true
      persist: false
      selectOnTab: true
      plugins: ['remove_button']
