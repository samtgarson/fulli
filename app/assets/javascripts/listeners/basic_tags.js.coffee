class @BasicTags extends Listener
  Listener.register @, 'basic-tags'
    
  instantiate: =>
    @el.selectize(@options.selectize)

  create: (input) ->
    value: input
    text: input

  _defaultOptions: =>
    selectize:
      create: @create
      persist: false
      selectOnTab: true
      plugins: ['remove_button']
