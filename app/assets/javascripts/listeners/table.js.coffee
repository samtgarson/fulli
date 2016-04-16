class @Table extends @Listener
  @className: 'table-wrapper'
  @classKey: 'Table'

  instantiate: =>
    @_bindEvents()
    @_bindClick()

  _bindEvents: =>
    $('body').on('table:reload', (e, body) =>
      @el.empty()
      @el.append(body)
      InstantSubmit.bindAll()
      Table.bindAll()
      Graph.bindAll()
    )

  _bindClick: =>
    @el.find('tr[data-link]').each ->
      $(this).addClass('clickable')
      
      $(this).click ->
        window.location = $(this).data('link')

