class @InstantSubmit extends Listener
  Listener.register @, '.instant-submit'

  instantiate: =>
    @_bindChange()

  _bindChange: =>
    @el.on('ajax:before', @_submitHandler)
    @el.find('input[name][id]').putCursorAtEnd()
    @el.find('input[name][id]').bindWithDelay('keyup', ( => 
      @el.submit()
    ), 300)

    @el.find('.selectized').each (i, el) =>
      $(el).data('selectize').on('change', => @el.submit())

  _submitHandler: (e) =>
    $('.filter-toggle.active').data('filter-toggle') == 'table' || !@el.is(e.target)
