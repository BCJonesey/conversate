ConversationsStore = new Structural.Flux.Store
  displayName: 'Conversations Store'
  initialize: ->
    @conversations = {}
  dispatches: [
    {
      action: Structural.Actions.UpdateConversationList
      callback: 'updateConversationList'
    }
  ]
  updateConversationList: (payload) ->
    @conversations = payload.conversations
    @trigger()

  conversationById: (id) ->
    @conversations[id]

Structural.Stores.ConversationsStore = ConversationsStore
