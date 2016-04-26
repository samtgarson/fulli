class @InstantSubmit extends Listener
  Listener.register @, '.instant-submit'

  instantiate: =>
    @_bindChange()
    @_bindSubmit()

  _bindSubmit: =>
    $(document).on('ajax:before', =>
      return $.active == 0
    )

  _bindChange: =>
    @el.find('input[name][id]').putCursorAtEnd()
    @el.find('input[name][id]').bindWithDelay('keyup', ( => 
      @el.submit()
    ), 300)

    @el.on('change', => 
      @el.submit()
    )
