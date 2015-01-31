{ContactLists, ActiveContactList, Contacts} = Structural.Stores
{div} = React.DOM

ContactsPane = React.createClass
  displayName: 'Contacts Pane'

  mixins: [
    ContactLists.listenWith('updateContacts')
    ActiveContactList.listenWith('updateContacts')
    Contacts.listenWith('updateContacts')
  ]

  updateContacts: ->
    contactList = ContactLists.byId(ActiveContactList.id())
    return {
      activeContactList: contactList
      contacts: Contacts.alphabeticalOrder(contactList)
    }

  render: ->
    {ContactsToolbar, Contact} = Structural.Components

    contacts = _.map @state.contacts, (contact) ->
      Contact
        contact: contact
        key: contact.id

    div {className: 'contacts-pane'},
      ContactsToolbar(activeContactList: @state.activeContactList),
      div {className: 'contacts'}
        contacts

Structural.Components.ContactsPane = React.createFactory(ContactsPane)
