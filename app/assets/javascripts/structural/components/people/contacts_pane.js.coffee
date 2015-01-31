{div} = React.DOM

ContactsPane = React.createClass
  displayName: 'Contacts'
  render: ->
    {ContactsToolbar} = Structural.Components

    div {className: 'contacts-pane'},
      ContactsToolbar()

Structural.Components.ContactsPane = React.createFactory(ContactsPane)
