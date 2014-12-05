Structural.Actions.UpdateConversationList = new Hippodrome.Action(
  'Update Conversation List'
  (conversations, folder) ->
    conversations: conversations
    folder: folder
)

Structural.Actions.UpdateActiveConversation = new Hippodrome.Action(
  'Update Active Conversation'
  (activeConversationId) -> {activeConversationId: activeConversationId})
