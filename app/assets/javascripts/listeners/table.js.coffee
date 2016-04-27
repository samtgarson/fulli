class @Table extends Listener
  Listener.register @, '.table-wrapper'

  instantiate: =>
    @_bindEvents()
    @_bindClick()

  _bindEvents: =>
    reloading = false
    $(document).on('table:reload', (e, body, display) =>
      return true if reloading
      reloading = true
      bod = $(body).hide()

      if @displayHasChanged(display)
        @el.empty().stop().animate({
          height: getHeight(body)
        }, 200, =>
          bod.appendTo(@el).fadeIn()
          Graph.bindSelf()
          @_bindClick()
          reloading = false
        )
      else
        @el.empty().append(bod.show())
        reloading = false
    )

  displayHasChanged: (display) =>
    $('.filter-toggle.active').data('filter-toggle') != display

  _bindClick: =>
    @el.find('tr[data-link]').each ->
      $(this).addClass('clickable')
      
      $(this).click ->
        window.location = $(this).data('link')

getHeight = (body) ->
  el = $(body).css('visibility', 'hidden')
  h = $(el).appendTo('body').height()
  el.remove()
  return h
