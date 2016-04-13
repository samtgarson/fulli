$ ->
  $('tr[data-link]').each ->
    $(this).addClass('clickable')
    
    $(this).click ->
      window.location = $(this).data('link')
