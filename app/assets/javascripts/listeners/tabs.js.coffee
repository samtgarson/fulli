class @Tabs extends Listener
  Listener.register @, '.tabs'

  instantiate: =>
    @links = $('[data-tab-target]')
    @wrapper = $('.tab-wrapper')
    @tabs = $('.tab')
    @activeTab = 0

    @_bindClicks()
    @gotoTab(@activeTab)

  gotoTab: (tab) =>
    @activeTab = tab
    @_updateHeight()
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

  _updateHeight: =>
    h = @tabs.filter('[data-tab=' + @activeTab + ']').height()
    @el.animate({height: h}, 200)

  _bindClicks: =>
    @links.click (e) =>
      @gotoTab $(e.target).data('tab-target')

  _defaultOptions: =>
