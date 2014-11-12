ConversationsState = new Hippodrome.Store
  displayName: 'Conversation State'
  initialize: ->
    @state = 'loading'
  dispatches: [{
    action: Structural.Actions.UpdateConversationList
    callback: 'loaded'
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

Structural.Stores.ConversationsState = ConversationsState
