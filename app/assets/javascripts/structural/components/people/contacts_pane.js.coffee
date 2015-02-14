{ContactLists, ActiveContactList} = Structural.Stores
{div} = React.DOM

ContactsPane = React.createClass
  displayName: 'Contacts Pane'

  mixins: [
    ContactLists.listenWith('updateContacts')
    ActiveContactList.listenWith('updateContacts')
  ]

  updateContacts: ->
    contactList = ContactLists.byId(ActiveContactList.id())
    return {
      activeContactList: contactList
      contacts: if contactList then ContactLists.alphabeticalContacts(contactList.id) else []
    }

  render: ->
    {ContactsToolbar, Contact, ContactsHeaders} = Structural.Components

    contacts = _.map @state.contacts, (contact) ->
      Contact
        contact: contact
        key: contact.id

    div {className: 'contacts-pane'},
      ContactsToolbar(activeContactList: @state.activeContactList)
      ContactsHeaders()
      div({className: 'contacts'}, contacts)

Structural.Components.ContactsPane = React.createFactory(ContactsPane)
