{ContactLists} = Structural.Stores
{div} = React.DOM

ContactListsPane = React.createClass
  displayName: 'Contact Lists Pane'

  mixins: [
    ContactLists.listen('lists', ContactLists.asList)
  ]

  render: ->
    {ContactListsToolbar, ContactList} = Structural.Components

    lists = _.map @state.lists, (list) ->
      ContactList {
        contactList: list
        key: list.id
      }

    div {className: 'contact-lists-pane'},
      ContactListsToolbar(),
      div({className: 'contact-lists'}, lists)


Structural.Components.ContactListsPane = React.createFactory(ContactListsPane)
