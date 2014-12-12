{buildMessage} = Structural.Data.Message
{nextId} = Structural.Data.TemporaryIdFactory

Structural.Actions.UpdateConversationList = new Hippodrome.Action(
  'Update Conversation List'
  (conversations, folder) ->
    conversations: conversations
    folder: folder
)

Structural.Actions.UpdateActiveConversation = new Hippodrome.Action(
  'Update Active Conversation'
  (activeConversationId) -> {activeConversationId: activeConversationId})

Structural.Actions.PinUnpinConversation = new Hippodrome.Action(
  'Pin Unpin Conversation'
  (pinned, conversation, folder, user) ->
    pinned: pinned
    conversation: conversation
    folder: folder
    user: user
)

Structural.Actions.ArchiveUnarchiveConversation = new Hippodrome.Action(
  'Archive Unarchive Conversation'
  (archived, conversation, folder, user) ->
    archived: archived
    conversation: conversation
    folder: folder
    user: user
)

Structural.Actions.RetitleConversation = new Hippodrome.Action(
  'Retitle Conversation'
  (title, conversation, folder, user) ->
    title: title
    message: buildMessage(user, {title: title}, 'retitle')
    temporaryId: nextId()
    conversation: conversation
    folder: folder
    user: user
)
