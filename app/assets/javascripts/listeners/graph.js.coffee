class Listeners.Graph extends Listener
  @listenerSelector: '.graph'

  constructor: ->
    @vis = []
    super

  instantiate: ->
    @vis = new vis.Network(@el[0], {
      nodes: @data('nodes'),
      edges: @data('edges')
    }, @options)
    
    @vis.fit()
    @_bindEvents()

  data: (key) ->
    new vis.DataSet(@el.data(key))

  find: (id) ->
    @data('nodes').get(id)

  _bindEvents: =>
    @vis.on('selectNode', @_goToNode)

  _goToNode: (e) => 
      window.location.href = @find(e.nodes[0]).url

  _defaultOptions: =>
    nodes:
      shape: 'circularImage'
      size: 30
      borderWidth: 0
      borderWidthSelected: 0
      color:
        border: 'transparent'
      font: 
        size: 10 
        face: 'Open Sans' 
        color: '#000000'
        background: 'white'
      scaling:
        label: 
          enabled: false
        min: 20
        max: 30
    edges:
      smooth: true
      color: '#FCB380'
      width: 2
    physics:
      enabled: false
    layout:
      hierarchical:
        enabled: true
        direction: 'UD'
        levelSeparation: 120
        nodeSpacing: 180
        edgeMinimization: true
        blockShifting: true
