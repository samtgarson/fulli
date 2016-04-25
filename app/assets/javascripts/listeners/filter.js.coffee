class @Filter extends Listener
  Listener.register @, '.filter'
    
  instantiate: =>
    @_bindEvents()

  _bindEvents: =>
    $(document).on('filter:toggle', @_toggleHandler)

  _toggleHandler: (e, arg) =>
    $('.filter-toggle')
      .removeClass('active')
      .filter('[data-filter-toggle=' + arg + ']')
      .addClass('active')
