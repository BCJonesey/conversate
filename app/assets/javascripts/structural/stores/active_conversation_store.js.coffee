ActiveConversationStore = new Structural.Flux.Store
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

Structural.Stores.ActiveConversationStore = ActiveConversationStore
