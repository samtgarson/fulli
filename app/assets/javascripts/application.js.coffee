#= require jquery
#= require jquery_ujs
#= require selectize
#= require bindWithDelay
#= require putCursorAtEnd
#= require cocoon
#= require particles.min
#= require rangeslider.min
#= require rating.min
#= require listener
#= require_tree .
#= require_self

$ ->
  particlesJS.load('particles-js', $('#particles-js').data('json-path'))
