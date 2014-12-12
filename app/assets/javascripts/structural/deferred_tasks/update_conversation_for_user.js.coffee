{updateConversationForUser} = Structural.Api.Conversations
{Conversations, CurrentUser} = Structural.Stores

UpdateConversationForUser = new Hippodrome.DeferredTask
  displayName: 'Update Conversation For User'
  dispatches: [{
    action: Structural.Actions.MarkRead
    callback: 'updateConversation'
  }, {
    action: Structural.Actions.PinUnpinConversation
    callback: 'updateConversation'
  }, {
    action: Structural.Actions.ArchiveUnarchiveConversation
    callback: 'updateConversation'
  }]

  updateConversation: (payload) ->
    convo = Conversations.byId(payload.folder, payload.conversation.id)
    user = CurrentUser.getUser()

    success = ->
    error = ->
    updateConversationForUser(convo, user, success, error)
