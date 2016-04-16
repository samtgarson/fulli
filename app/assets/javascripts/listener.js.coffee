class @Listener
  @bindAll: ->
    $('.' + @className).each (i, el) =>
      klass = @constructor
      $(el).data(@className, new window[@classKey]($(el)))

  constructor: (@el) ->
    @options = @mergeOptions()
    @instantiate()

  mergeOptions: =>
    $.extend(true, {}, @_defaultOptions(), (@el.data('options') || {}))

  _defaultOptions: => 
    {}
