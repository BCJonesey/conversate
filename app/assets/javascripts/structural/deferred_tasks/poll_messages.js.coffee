{Conversations, ActiveConversation, Folders, ActiveFolder} = Structural.Stores
{arrayToIndexedHash} = Structural.Data.Collection

POLL_INTERVAL = 5 * 1000

PollMessages = Hippodrome.createDeferredTasks
  initialize: (options) ->
    doPoll = ->
      activeFolder = Folders.byId(ActiveFolder.id())
      activeConversation = Conversations.byId(activeFolder, ActiveConversation.id())

      if not activeConversation
        setTimeout(doPoll, POLL_INTERVAL)
        return

      success = (data) ->
        Structural.Actions.UpdateMessagesList(arrayToIndexedHash(data), activeConversation)
        setTimeout(doPoll, POLL_INTERVAL)
      error = ->
        setTimeout(doPoll, POLL_INTERVAL)

      Structural.Api.Messages.index(activeConversation, success, error)

    setTimeout(doPoll, POLL_INTERVAL)

Structural.Tasks.PollMessages = PollMessages
