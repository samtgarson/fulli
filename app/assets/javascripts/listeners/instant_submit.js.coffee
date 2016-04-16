class @InstantSubmit extends Listener
  Listener.register @, 'instant-submit'

  instantiate: =>
    @_bindChange()

  _bindChange: =>
    @el.find('[type=text]').putCursorAtEnd().bindWithDelay('keyup', ( => 
      @el.submit()
    ), 300)
