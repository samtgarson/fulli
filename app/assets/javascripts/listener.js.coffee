class @Listener

  @bindAll: (e) =>
    for name, cls of Listeners
      cls.bindSelf()

  @bindSelf: ->
    @instances ?= []
    $(@listenerSelector).each (i, el) =>
      unless $(el).data('listener')?
        instance = new @($(el))
        $(el).data('listener', instance)
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

@Listeners = {}
