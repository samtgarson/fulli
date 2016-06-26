$ ->
  $('.show-hide-toggle').click (e) ->
    e.preventDefault()
    target = $(e.target).data('target')
    $(target).toggleClass('open')
    Listeners.Tabs.instances[0].updateHeight()
