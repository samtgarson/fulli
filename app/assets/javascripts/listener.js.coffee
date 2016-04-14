class @Listener
  @bindAll: ->
    $('.' + @className).each (i, el) =>
      klass = @constructor
      $(el).data(@className, new window[@classKey]($(el)))

  constructor: (@el) ->
    @instantiate()
