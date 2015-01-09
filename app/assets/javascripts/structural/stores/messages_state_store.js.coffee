#= require ./conversations_store
#= require ./active_conversation_store

MessagesState = Hippodrome.createStore
  displayName: 'Messages State'
  initialize: ->
    @state = 'loading'

    @dispatch(Structural.Actions.UpdateMessagesList).to(@loaded)
    @dispatch(Structural.Actions.UpdateActiveConversation)
      .to(@loadingConversation)
    @dispatch(Structural.Actions.UpdateActiveFolder)
      .after(Structural.Stores.ActiveConversation)
      .to(@loadingFolder)
    @dispatch(Structural.Actions.UpdateConversationList)
      .after(Structural.Stores.Conversations)
      .to(@noneOnEmpty)

  loaded: (payload) ->
    @state = 'loaded'
    @trigger()
  loadingConversation: (payload) ->
    activeFolder = Structural.Stores.Folders.byId(Structural.Stores.ActiveFolder.id())
    activeConvo = Structural.Stores.Conversations.byId(activeFolder, payload.activeConversationId)
    if Structural.Stores.Messages.isEmpty(activeConvo)
      @state = 'loading'
      @trigger()
  loadingFolder: (payload) ->
    activeFolder = Structural.Stores.Folders.byId(payload.activeFolderId)
    activeConvo = Structural.Stores.Conversations.byId(activeFolder, Structural.Stores.ActiveConversation.id())
    if Structural.Stores.Messages.isEmpty(activeConvo)
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
