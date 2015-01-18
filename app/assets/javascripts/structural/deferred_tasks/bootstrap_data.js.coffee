{arrayToIndexedHash} = Structural.Data.Collection

BootstrapData = Hippodrome.createDeferredTask
  initialize: (options) ->
    folders = arrayToIndexedHash(bootstrap.folders)
    activeFolderId = if bootstrap.folder then bootstrap.folder.id else null
    conversations = arrayToIndexedHash(bootstrap.conversations)
    activeConversationId = if bootstrap.conversation then bootstrap.conversation.id else null

    messages = arrayToIndexedHash(bootstrap.actions)

    Structural.Actions.UpdateFolderList(folders)
    Structural.Actions.UpdateConversationList(conversations, bootstrap.folder)
    Structural.Actions.UpdateMessagesList(messages, bootstrap.conversation)
    Structural.Actions.UpdateCurrentUser(bootstrap.user)

Structural.Tasks.BootstrapData = BootstrapData
