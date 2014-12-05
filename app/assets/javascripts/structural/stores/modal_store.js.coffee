Modal = new Hippodrome.Store
  displayName: 'Modal Store'
  initialize: ->
    @_open = false
    @_content = undefined
  dispatches: [{
    action: Structural.Actions.OpenModal
    callback: 'openModal'
  }]

  openModal: (payload) ->
    @_open = true
    @_content = payload.content
    @trigger()

  public:
    open: () -> @_open
    content: () -> @_content

Structural.Stores.Modal = Modal
