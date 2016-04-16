class @Listener
  @classes: []

  @register: (cls, key) =>
    if key? && key.length
      @classes.push cls
      cls.listener_key = key

  @bindAll: (e) =>
    for cls in @classes
      cls.bindSelf()

  @bindSelf: ->
    $('.' + @listener_key).each (i, el) =>
      klass = @constructor
      $(el).data(@listener_key, new window[@name]($(el)))

  constructor: (@el) ->
    @options = @mergeOptions()
    @instantiate()

  mergeOptions: =>
    $.extend(true, {}, @_defaultOptions(), (@el.data('options') || {}))

  _defaultOptions: => 
    {}

$ ->
  setTimeout Listener.bindAll, 0
