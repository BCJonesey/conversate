Modal = new Hippodrome.Store
  displayName: 'Modal Store'
  initialize: ->
    @_open = false
    @_content = undefined
    @_title = undefined
  dispatches: [{
    action: Structural.Actions.OpenModal
    callback: 'openModal'
  }]

  openModal: (payload) ->
    @_open = true
    @_content = payload.content
    @_title = payload.title
    @trigger()

  public:
    open: () -> @_open
    content: () -> @_content
    title: () -> @_title

Structural.Stores.Modal = Modal
