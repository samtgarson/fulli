class @Table extends Listener
  Listener.register @, '.table-wrapper'

  instantiate: =>
    @_bindEvents()
    @_bindClick()

  _bindEvents: =>
    $(document).on('table:reload', (e, body) =>
      h = getHeight(body)
      bod = $(body).hide()

      @el
        .empty()
        .animate({height: h}, 200, =>
          bod.appendTo(@el).fadeIn()
          Listener.bindAll()
          @_bindClick()
        )
    )

  _bindClick: =>
    @el.find('tr[data-link]').each ->
      $(this).addClass('clickable')
      
      $(this).click ->
        window.location = $(this).data('link')

getHeight = (body) ->
  el = $(body)
  el.css('visibility', 'hidden')
  $('body').append(el)
  el.height()
