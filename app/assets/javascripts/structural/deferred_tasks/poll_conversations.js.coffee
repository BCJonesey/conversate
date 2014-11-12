{Folders, ActiveFolder} = Structural.Stores
{UpdateConversationList} = Structural.Actions
{arrayToIndexedHash} = Structural.Data.Collection

POLL_INTERVAL = 5 * 1000

PollConversations = new Hippodrome.DeferredTask
  action: Structural.Actions.StartApp
  task: (payload) ->
    doPoll = ->
      activeFolder = Folders.byId(ActiveFolder.id())

      success = (data) ->
        UpdateConversationList(arrayToIndexedHash(data), activeFolder)
        setTimeout(doPoll, POLL_INTERVAL)
      error = ->
        setTimeout(doPoll, POLL_INTERVAL)

      Structural.Api.Conversations.index(activeFolder, success, error)

    setTimeout(doPoll, POLL_INTERVAL)

Structural.Tasks.PollConversations = PollConversations
