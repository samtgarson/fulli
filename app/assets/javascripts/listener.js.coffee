class @Listener
  @classes: []

  @register: (cls, key) =>
    if key? && key.length
      @classes.push cls
      cls.listenerSelector = key
      cls.instances = []

  @bindAll: (e) =>
    for cls in @classes
      cls.bindSelf()

  @bindSelf: ->
    $(@listenerSelector).each (i, el) =>
      klass = @constructor
      if !$(el).data(@listenerSelector)?
        instance = new window[@name]($(el))
        $(el).data(@name, instance)
        @instances.push instance

  constructor: (@el) ->
    @options = @mergeOptions()
    @instantiate()

  mergeOptions: =>
    $.extend(true, {}, @_defaultOptions(), (@el.data('options') || {}))

  _defaultOptions: => 
    {}

$ ->
  setTimeout Listener.bindAll, 0
