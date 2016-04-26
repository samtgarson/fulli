class @Filter extends Listener
  Listener.register @, '.filter'
    
  instantiate: =>
    @_bindEvents()

  _bindEvents: =>
    $(document).on('filter:toggle', @_toggleHandler)
    $(document).on('filter:hide', @_hideFilter)
    $(document).on('filter:show', @_showFilter)

    $(document).on('filter:hide filter:show', =>
      @el.addClass('transitioning')
    )
    @el.on('webkitTransitionEnd otransitionend oTransitionEnd msTransitionEnd transitionend', =>
      @el.removeClass('transitioning')
    )

  _hideFilter: (e) =>
    @el.addClass('hidden')

  _showFilter: (e) =>
    @el.removeClass('hidden')

  _toggleHandler: (e, arg) =>
    $('.filter-toggle')
      .removeClass('active')
      .filter('[data-filter-toggle=' + arg + ']')
      .addClass('active')
