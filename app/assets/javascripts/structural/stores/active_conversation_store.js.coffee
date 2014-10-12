ActiveConversation = new Hippodrome.Store
  displayName: 'Active Conversation Store'
  initialize: ->
    @activeConversationId = null
  dispatches: [
    {
      action: Structural.Actions.UpdateActiveConversation
      callback: 'updateActiveConversationId'
    }
  ]
  updateActiveConversationId: (payload) ->
    @activeConversationId = payload.activeConversationId
    @trigger()

  id: ->
    @activeConversationId

Structural.Stores.ActiveConversation = ActiveConversation
