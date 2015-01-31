{name} = Structural.Data.Participant
{hashToSortedArray} = Structural.Data.Collection

Contacts = Hippodrome.createStore
  displayName: 'Contacts Store'
  initialize: ->
    @_contactsByContactList = {}

    @dispatch(Structural.Actions.UpdateContacts).to(@updateContacts)

  updateContacts: (payload) ->
    _.assign(@contactsForList(payload.contactList), payload.contacts)
    @trigger()

  contactsForList: (contactList) ->
    if not contactList
      return {}

    if not @_contactsByContactList[contactList.id]
      @_contactsByContactList[contactList.id] = {}

    @_contactsByContactList[contactList.id]

  contactName: (contact) ->
    name(contact.user)

  public:
    alphabeticalOrder: (contactList) ->
      hashToSortedArray(@contactsForList(contactList), @contactName)

Structural.Stores.Contacts = Contacts
