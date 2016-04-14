class @InstantSubmit extends @Listener
  @className: 'instant-submit'
  @classKey: 'InstantSubmit'

  instantiate: ->
    @_bindChange()

  _bindChange: =>
    @el.find('[type=text]').putCursorAtEnd().bindWithDelay('keyup', ( => 
      @el.submit()
    ), 300)
