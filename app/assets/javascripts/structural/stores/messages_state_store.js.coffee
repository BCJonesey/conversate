#= require ./conversations_store
#= require ./active_conversation_store

MessagesState = new Hippodrome.Store
  displayName: 'Messages State'
  initialize: ->
    @state = 'loading'
  dispatches: [{
    action: Structural.Actions.UpdateMessagesList
    callback: 'loaded'
  }, {
    action: Structural.Actions.UpdateActiveConversation
    callback: 'loadingConversation'
  }, {
    action: Structural.Actions.UpdateActiveFolder
    callback: 'loadingFolder'
    after: [Structural.Stores.ActiveConversation]
  }, {
    action: Structural.Actions.UpdateConversationList
    callback: 'noneOnEmpty'
    after: [Structural.Stores.Conversations]
  }]

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
