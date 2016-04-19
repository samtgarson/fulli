class @Table extends Listener
  Listener.register @, '.table-wrapper'

  instantiate: =>
    @_bindEvents()
    @_bindClick()

  _bindEvents: =>
    $('body').on('table:reload', (e, body) =>
      @el.empty()
      @el.append(body)
      Listener.bindAll()
    )

  _bindClick: =>
    @el.find('tr[data-link]').each ->
      $(this).addClass('clickable')
      
      $(this).click ->
        window.location = $(this).data('link')

