ConversationsState = Hippodrome.createStore
  displayName: 'Conversation State'
  initialize: ->
    @state = 'loading'

    @dispatch(Structural.Actions.UpdateConversationList).to(@loaded)
    @dispatch(Structural.Actions.UpdateActiveFolder).to(@loading)

  loaded: (payload) ->
    @state = 'loaded'
    @trigger()
  loading: (payload) ->
    folder = Structural.Stores.Folders.byId(payload.activeFolderId)
    if Structural.Stores.Conversations.isEmpty(folder)
      @state = 'loading'
      @trigger()

  public:
    isLoading: -> @state == 'loading'

Structural.Stores.ConversationsState = ConversationsState
