$ ->
  $('.flash-wrapper').each ->
    el = $(this)
    setTimeout ( ->
      el.fadeOut()
    ), 5000
