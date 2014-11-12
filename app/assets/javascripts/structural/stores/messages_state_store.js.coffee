MessagesState = new Hippodrome.Store
  displayName: 'Messages State'
  initialize: ->
    @state = 'loading'
  dispatches: [{
    action: Structural.Actions.UpdateMessagesList
    callback: 'loaded'
  }, {
    action: Structural.Actions.UpdateActiveConversation
    callback: 'loading'
  }, {
    action: Structural.Actions.UpdateActiveFolder
    callback: 'loading'
  }]

  loaded: (payload) ->
    @state = 'loaded'
    @trigger()
  loading: (payload) ->
    @state = 'loading'
    @trigger()

  public:
    isLoading: -> @state == 'loading'

Structural.Stores.MessagesState = MessagesState
