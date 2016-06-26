class Listeners.Tabs extends Listener
  @listenerSelector: '.tabs'

  instantiate: =>
    @links = $('[data-tab-target]')
    @wrapper = $('.tab-wrapper')
    @tabs = $('.tab')
    @activeTab = 0

    # @wrapper.css('position', 'fixed')
    # setTimeout (=> @wrapper.css('position', 'absolute')), 0

    @_bindClicks()
    @gotoTab(@activeTab)

  gotoTab: (tab) =>
    @activeTab = tab
    @updateHeight()
    @_updateLinks()
    @_slideTabs()

  _slideTabs: =>
    step = -100 / @tabs.length
    @wrapper.css('transform', 'translateX(' + (step * @activeTab) + '%)')
    @tabs.removeClass('active').filter('[data-tab=' + @activeTab + ']').addClass('active')

  _updateLinks: =>
    @links
      .removeClass('active')
      .filter('[data-tab-target=' + @activeTab + ']')
      .addClass('active')

  updateHeight: =>
    h = @tabs.filter('[data-tab=' + @activeTab + ']').height()
    @el.animate({height: h}, 200)

  _bindClicks: =>
    @links.click (e) =>
      @gotoTab $(e.target).data('tab-target')

  _defaultOptions: =>
