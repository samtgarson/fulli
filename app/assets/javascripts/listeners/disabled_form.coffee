class @DisabledForm extends Listener
  Listener.register @, 'form[data-disabled=true]'
    
  instantiate: =>
    @disableAll()

  disableAll: =>
    @_disableInputs()
    @_disableSelectize()

  _disableSelectize: =>
    @el.find('.selectized').each ->
      $(this)[0].selectize.disable()

  _disableInputs: =>
    @el.find('select, input').attr('disabled', true)
