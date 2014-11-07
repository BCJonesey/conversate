{Conversations, ActiveConversation} = Structural.Stores
{arrayToIndexedHash} = Structural.Data.Collection

POLL_INTERVAL = 5 * 1000

PollMessages = new Hippodrome.DeferredTask
  action: Structural.Actions.StartApp
  task: (payload) ->
    doPoll = ->
      activeConversation = Conversations.byId(ActiveConversation.id())

      success = (data) ->
        Structural.Actions.UpdateMessagesList(arrayToIndexedHash(data), activeConversation)
        setTimeout(doPoll, POLL_INTERVAL)
      error = ->
        setTimeout(doPoll, POLL_INTERVAL)

      Structural.Api.Messages.index(activeConversation, success, error)

    setTimeout(doPoll, POLL_INTERVAL)

Structural.Tasks.PollMessages = PollMessages
