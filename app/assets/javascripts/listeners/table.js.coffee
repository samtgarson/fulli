class Listeners.Table extends Listener
  @listenerSelector: '.table-wrapper'

  instantiate: =>
    @_bindEvents()
    @_bindClick()

  _bindEvents: =>
    reloading = false
    $(document)
      .on('table:reload', @replaceTable)
      .on('table:reloadRow', @replaceRow)

  displayHasChanged: (display) =>
    $('.filter-toggle.active').data('filter-toggle') != display

  replaceRow: (e, body, id) =>
    @el.find('tr[data-id=' + id + ']').replaceWith body 

  replaceTable: (e, body, display) =>
    return true if reloading
    reloading = true
    bod = $(body).hide()

    if @displayHasChanged(display)
      @el.empty().stop().animate({
        height: getHeight(body)
      }, 200, =>
        bod.appendTo(@el).fadeIn()
        Listener.bindAll()
        @_bindClick()
        reloading = false
      )
    else
      @el.empty().append(bod.show())
      Listener.bindAll()
      @_bindClick()
      reloading = false

  _bindClick: =>
    @el.find('tr[data-link]').each ->
      $(this).addClass('clickable')
      
      $(this).on('click touchend', ->
        window.location = $(this).data('link'))

getHeight = (body) ->
  el = $(body).css('visibility', 'hidden')
  h = $(el).appendTo('body').height()
  el.remove()
  return h
