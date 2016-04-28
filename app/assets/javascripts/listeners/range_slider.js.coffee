class @RangeSlider extends Listener
  @registerListener 'input[type=range]'
    
  instantiate: =>
    @el.rangeslider(@options)
    @value = $('<h2 class="slider-value">').appendTo(@el.parent()).text(@el.val())

  _changeHandler: (pos, val) =>
    @value.text(val)

  _defaultOptions: =>
    polyfill: false,
    onSlide: @_changeHandler
