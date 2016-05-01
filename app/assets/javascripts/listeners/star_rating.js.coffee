class Listeners.starrating extends Listener
  @listenerSelector: '.star-rating'
    
  instantiate: =>
    @input = @el.find('input').hide()
    @value = $('<h2 class="slider-value">').appendTo(@el)
    @value.text(@input.val()) unless @input.val() == '0'

    wrapper = $('<ul class="rating-wrapper"></ul>').prependTo(@el)
    @instance = rating(wrapper[0], @input.val(), 5, @_changeHandler)

  _changeHandler: (val) =>
    @value.text(val)
    @input.val(val)

  _defaultOptions: =>
    polyfill: false,
    onSlide: @_changeHandler
