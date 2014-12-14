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

    # In the case where this gets triggered because of an update folders message
    # that removes the conversation from the active folder, we don't have a
    # quick way to get to the conversation anymore, so screw it.
    if convo
      user = CurrentUser.getUser()

      success = ->
      error = ->
      updateConversationForUser(convo, user, success, error)
