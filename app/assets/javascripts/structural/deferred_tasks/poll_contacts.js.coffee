{ContactLists, ActiveContactList} = Structural.Stores
{arrayToIndexedHash} = Structural.Data.Collection

POLL_INTERVAL = 5 * 1000

PollContacts = Hippodrome.createDeferredTask
  displayName: 'Poll Contacts'
  initialize: (options) ->
    doPoll = ->
      activeContactList = ContactLists.byId(ActiveContactList.id())

      if not activeContactList
        setTimeout(doPoll, POLL_INTERVAL)
        return

      success = (data) ->
        Structural.Actions.UpdateContacts(arrayToIndexedHash(data),
                                          activeContactList)
        setTimeout(doPoll, POLL_INTERVAL)
      error = ->
        setTimeout(doPoll, POLL_INTERVAL)

      Structural.Api.People.contacts(activeContactList, success, error)

    setTimeout(doPoll, POLL_INTERVAL)

Structural.Tasks.PollContacts = PollContacts
