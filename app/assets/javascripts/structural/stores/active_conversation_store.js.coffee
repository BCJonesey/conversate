#= require ./conversations_store

ActiveConversation = new Hippodrome.Store
  displayName: 'Active Conversation Store'
  initialize: ->
    @activeConversationId = null
  dispatches: [{
    action: Structural.Actions.UpdateActiveConversation
    callback: 'updateActiveConversationId'
  }, {
    action: Structural.Actions.UpdateConversationList
    callback: 'pickFirstIdIfNotInConversationList'
    after: [Structural.Stores.Conversations]
  }, {
    action: Structural.Actions.UpdateActiveFolder
    callback: 'pickFirstIdIfNotInFolder'
  }, {
    action: Structural.Actions.UpdateFolders
    callback: 'pickFirstIfRemoved'
  }]

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
