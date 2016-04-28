class @Filter extends Listener
  @registerListener '.filter'
    
  instantiate: =>
    @_bindEvents()

  _bindEvents: =>
    $(document).on('filter:toggle', @_toggleHandler)
    $(document).on('filter:hide', @_hideFilter)
    $(document).on('filter:show', @_showFilter)

  _hideFilter: (e) =>
    @el.addClass('hidden')

  _showFilter: (e) =>
    @el.removeClass('hidden')

  _toggleHandler: (e, arg) =>
    $('.filter-toggle')
      .removeClass('active')
      .filter('[data-filter-toggle=' + arg + ']')
      .addClass('active')
