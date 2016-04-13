$ ->
  $('.flash-wrapper').each ->
    el = $(this)
    el.hide().fadeIn(300)
    setTimeout ( ->
      el.fadeOut()
    ), 5000
