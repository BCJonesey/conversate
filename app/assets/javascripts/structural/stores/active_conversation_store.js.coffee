#= require ./conversations_store

ActiveConversation = Hippodrome.createStore
  displayName: 'Active Conversation Store'
  initialize: ->
    @activeConversationId = null

    @dispatch(Structural.Actions.UpdateActiveConversation)
      .to(@updateActiveConversationId)
    @dispatch(Structural.Actions.UpdateConversationList)
      .after(Structural.Stores.Conversations)
      .to(@pickFirstIdIfNotInConversationList)
    @dispatch(Structural.Actions.UpdateActiveFolder)
      .to(@pickFirstIdIfNotInFolder)
    @dispatch(Structural.Actions.UpdateFolders).to(@pickFirstIfRemoved)

  updateActiveConversationId: (payload) ->
    @activeConversationId = Number(payload.activeConversationId)
    @trigger()
  pickFirstIdIfNotInConversationList: (payload) ->
    if not payload.conversations[@activeConversationId]
      activeFolder = Structural.Stores.Folders.byId(Structural.Stores.ActiveFolder.id())
      firstConvo = _.first(Structural.Stores.Conversations.chronologicalOrder(activeFolder))

      @activeConversationId = if firstConvo then firstConvo.id else undefined
      @trigger()
  pickFirstIdIfNotInFolder: (payload) ->
    activeFolder = Structural.Stores.Folders.byId(payload.activeFolderId)
    if not Structural.Stores.Conversations.byId(activeFolder, @activeConversationId)
      conversationsList = Structural.Stores.Conversations.chronologicalOrder(activeFolder)
      firstConvo = _.first(conversationsList)

      @activeConversationId = if firstConvo then firstConvo.id else undefined
      @trigger()
  pickFirstIfRemoved: (payload) ->
    if payload.folder.id in _.pluck(payload.removed, 'id')
      conversationList = Structural.Stores.Conversations.chronologicalOrder(payload.folder)
      firstConvo = _.first(conversationList)

      @activeConversationId = if firstConvo then firstConvo.id else undefined
      @trigger()

  public:
    id: -> @activeConversationId

Structural.Stores.ActiveConversation = ActiveConversation
