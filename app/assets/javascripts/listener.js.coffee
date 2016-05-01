class @Listener

  @bindAll: (e) =>
    for name, cls of Listeners
      cls.bindSelf()

  @bindSelf: ->
    @instances ?= []
    $(@listenerSelector).each (i, el) =>
      unless $(el).data(@name)?
        instance = new Listeners[@name]($(el))
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

@Listeners = {}
