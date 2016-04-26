class @Table extends Listener
  Listener.register @, '.table-wrapper'

  instantiate: =>
    @_bindEvents()
    @_bindClick()

  _bindEvents: =>
    reloading = false
    $(document).on('table:reload', (e, body) =>
      return true if reloading
      reloading = true
      h = getHeight(body)
      bod = $(body).hide()

      @el
        .empty()
        .stop().animate({height: h}, 200, =>
          bod.appendTo(@el).fadeIn()
          Graph.bindSelf()
          @_bindClick()
          reloading = false
        )
    )

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
