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
    callback: 'pickFirstIdIfNotThere'
    after: [Structural.Stores.Conversations]
  }]

  updateActiveConversationId: (payload) ->
    @activeConversationId = payload.activeConversationId
    @trigger()
  pickFirstIdIfNotThere: (payload) ->
    if not payload.conversations[@activeConversationId]
      activeFolder = Structural.Stores.Folders.byId(Structural.Stores.ActiveFolder.id())
      firstConvo = _.first(Structural.Stores.Conversations.chronologicalOrder(activeFolder))

      @activeConversationId = if firstConvo then firstConvo.id else undefined
      @trigger()

  public:
    id: -> @activeConversationId

Structural.Stores.ActiveConversation = ActiveConversation
