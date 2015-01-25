{CurrentUser} = Structural.Stores
{UpdateContactLists} = Structural.Actions
{index} = Structural.Api.People
{arrayToIndexedHash} = Structural.Data.Collection

POLL_INTERVAL = 5 * 1000

PollContactLists = Hippodrome.createDeferredTask
  displayName: 'Poll Contact Lists'
  initialize: (options) ->
    doPoll = ->
      success = (data) ->
        UpdateContactLists(arrayToIndexedHash(data))
        setTimeout(doPoll, POLL_INTERVAL)
      error = ->
        setTimeout(doPoll, POLL_INTERVAL)

      index(CurrentUser.getUser(), success, error)

    setTimeout(doPoll, POLL_INTERVAL)

Structural.Tasks.PollContactLists = PollContactLists
