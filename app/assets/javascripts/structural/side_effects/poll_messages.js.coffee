{Conversations, ActiveConversation} = Structural.Stores
{arrayToIndexedHash} = Structural.Data.Collection

POLL_INTERVAL = 5 * 1000

PollMessages = new Hippodrome.SideEffect
  action: Structural.Actions.StartApp
  effect: (payload) ->
    doPoll = ->
      success = (data) ->
        Structural.Actions.UpdateMessagesList(arrayToIndexedHash(data))
        setTimeout(doPoll, POLL_INTERVAL)
      error = ->
        setTimeout(doPoll, POLL_INTERVAL)

      activeConversation = Conversations.byId(ActiveConversation.id())
      Structural.Api.Messages.index(activeConversation, success, error)

    setTimeout(doPoll, POLL_INTERVAL)
