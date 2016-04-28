class @Humans extends Listener
  @registerListener '.humans'
    
  instantiate: =>
    @el.selectize(@options.selectize)

  _loadFunction: (query, cb) ->
    if query.length < 3 then return cb()
    $.ajax
      url: @options.action
      type: 'GET'
      dataType: 'json'
      data: $.merge({}, @options.ajax, query: query)
      error: ->
        cb()
      success: (res) ->
        cb(res)

  _renderOption: (item, escape) ->
    '<div class="option">' +
      '<img class="avatar" src="' + escape(item.avatar_url) + '"/>' +
      escape(item.name) +
      ' <span>' + escape(item.title) + '</span>' +
    '</div>'

  _renderItem: (item, escape) ->
    '<div class="item">' +
      '<img class="avatar" src="' + escape(item.avatar_url) + '"/>' +
      escape(item.name) +
    '</div>'

  _defaultOptions: =>
    selectize:
      create: false
      valueField: 'id'
      labelField: 'name'
      searchField: 'name'
      copyClassesToDropdown: false
      load: @_loadFunction
      options: []
      items: []
      render:
        option: @_renderOption
        item: @_renderItem
    ajax:
      per: 1000
