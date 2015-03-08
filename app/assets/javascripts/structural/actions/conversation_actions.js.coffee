{buildMessage} = Structural.Data.Message
{nextId} = Structural.Data.TemporaryIdFactory

Structural.Actions.UpdateConversationList = Hippodrome.createAction
  displayName: 'Update Conversation List'
  build: (conversations, folder) ->
    conversations: conversations
    folder: folder

Structural.Actions.UpdateActiveConversation = Hippodrome.createAction
  displayName: 'Update Active Conversation'
  build: (activeConversationId) -> {activeConversationId: activeConversationId}

Structural.Actions.PinUnpinConversation = Hippodrome.createAction
  displayName: 'Pin Unpin Conversation'
  build: (pinned, conversation, folder, user) ->
    pinned: pinned
    conversation: conversation
    folder: folder
    user: user

Structural.Actions.ArchiveUnarchiveConversation = Hippodrome.createAction
  displayName: 'Archive Unarchive Conversation'
  build: (archived, conversation, folder, user) ->
    archived: archived
    conversation: conversation
    folder: folder
    user: user

Structural.Actions.RetitleConversation = Hippodrome.createAction
  displayName: 'Retitle Conversation'
  build: (title, conversation, folder, user) ->
    title: title
    message: buildMessage(user, {title: title}, 'retitle')
    temporaryId: nextId()
    conversation: conversation
    folder: folder
    user: user

Structural.Actions.UpdateFolders = Hippodrome.createAction
  displayName: 'Update Folders'
  build: (added, removed, conversation, folder, user) ->
    added: added
    removed: removed
    message: buildMessage(user, {added: added, removed: removed}, 'update_folders')
    temporaryId: nextId()
    conversation: conversation
    folder: folder
    user: user

Structural.Actions.UpdateUsers = Hippodrome.createAction
  displayName: 'Update Users'
  build: (added, removed, conversation, folder, user) ->
    added: added
    removed: removed
    message: buildMessage(user, {added: added, removed: removed}, 'update_users')
    temporaryId: nextId()
    conversation: conversation
    folder: folder
    user: user
