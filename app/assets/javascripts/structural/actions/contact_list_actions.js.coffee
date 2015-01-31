Structural.Actions.UpdateContactLists = Hippodrome.createAction
  displayName: 'Update Contact Lists'
  build: (lists) ->
    contactLists: lists

Structural.Actions.UpdateActiveContactList = Hippodrome.createAction
  displayName: 'Update Active Contact List'
  build: (id) ->
    contactListId: id

Structural.Actions.UpdateContacts = Hippodrome.createAction
  displayName: 'Update Contacts'
  build: (contacts, contactList) ->
    contacts: contacts
    contactList: contactList
