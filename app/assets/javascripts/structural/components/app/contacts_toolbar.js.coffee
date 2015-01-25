{div} = React.DOM

ContactsToolbar = React.createClass
  displayName: 'Contacts Toolbar'
  render: ->
    div {className: 'contacts-toolbar'}

Structural.Components.ContactsToolbar = React.createFactory(ContactsToolbar)
