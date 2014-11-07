{arrayToIndexedHash} = Structural.Data.Collection

BootstrapData = new Hippodrome.DeferredTask
  action: Structural.Actions.StartApp
  task: (payload) ->
    # This is a much more convenient way to store conversations for components
    # to pull them out of the stores.  I think.
    conversations = arrayToIndexedHash(bootstrap.conversations)
    activeConversationId = if bootstrap.conversation then bootstrap.conversation.id else null

    messages = arrayToIndexedHash(bootstrap.actions)

    Structural.Actions.UpdateConversationList(conversations)
    Structural.Actions.UpdateActiveConversation(activeConversationId)
    Structural.Actions.UpdateMessagesList(messages, bootstrap.conversation)
    Structural.Actions.UpdateCurrentUser(bootstrap.user)

Structural.Tasks.BootstrapData = BootstrapData
