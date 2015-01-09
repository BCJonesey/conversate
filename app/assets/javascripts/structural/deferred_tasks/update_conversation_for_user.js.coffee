{updateConversationForUser} = Structural.Api.Conversations
{Conversations, CurrentUser} = Structural.Stores

UpdateConversationForUser = Hippodrome.createDeferredTask
  displayName: 'Update Conversation For User'
  initialize: (options) ->
    @dispatch(Structural.Actions.MarkRead).to(@updateConversation)
    @dispatch(Structural.Actions.PinUnpinConversation).to(@updateConversation)
    @dispatch(Structural.Actions.ArchiveUnarchiveConversation)
      .to(@updateConversation)

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
