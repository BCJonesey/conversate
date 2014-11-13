#= ./conversations_store

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
  }, {
    action: Structural.Actions.UpdateConversationList
    callback: 'noneOnEmpty'
    after: [Structural.Stores.Conversations]
  }]

  loaded: (payload) ->
    @state = 'loaded'
    @trigger()
  loading: (payload) ->
    @state = 'loading'
    @trigger()
  noneOnEmpty: (payload) ->
    if Structural.Stores.Conversations.isEmpty(payload.folder)
      @state = 'none'
      @trigger()

  public:
    isLoading: -> @state == 'loading'
    isNone: -> @state == 'none'

Structural.Stores.MessagesState = MessagesState
