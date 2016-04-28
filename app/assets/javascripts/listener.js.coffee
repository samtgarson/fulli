class @Listener
  @classes: []

  @bindAll: (e) =>
    for cls in Listener.classes
      cls.bindSelf()

  @bindSelf: ->
    $(@listenerSelector).each (i, el) =>
      unless $(el).data(@name)?
        instance = new window[@name]($(el))
        $(el).data(@name, instance)
        @instances.push instance

  @registerListener: (key) ->
    if key? && key.length
      Listener.classes.push @
      @listenerSelector = key
      @instances = []

  constructor: (@el) ->
    @options = @mergeOptions()
    @instantiate()

  mergeOptions: =>
    $.extend(true, {}, @_defaultOptions(), (@el.data('options') || {}))

  _defaultOptions: => 
    {}

$ ->
  setTimeout Listener.bindAll, 0
