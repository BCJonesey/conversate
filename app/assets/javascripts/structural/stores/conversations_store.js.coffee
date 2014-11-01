{hashToSortedArray} = Structural.Data.Collection

Conversations = new Hippodrome.Store
  displayName: 'Conversations Store'
  initialize: ->
    @conversations = {}
  dispatches: [
    {
      action: Structural.Actions.UpdateConversationList
      callback: 'updateConversationList'
    }
    {
      action: Structural.Actions.MarkRead
      callback: 'updateMostRecentViewed'
    }
  ]

  updateConversationList: (payload) ->
    @conversations = payload.conversations
    @trigger()

  updateMostRecentViewed: (payload) ->
    convo = @byId(payload.conversation.id)
    convo.most_recent_viewed = payload.message.timestamp
    @trigger()

  public:
    byId: (id) -> @conversations[id]
    chronologicalOrder: -> hashToSortedArray(@conversations, 'most_recent_event')

Structural.Stores.Conversations = Conversations
