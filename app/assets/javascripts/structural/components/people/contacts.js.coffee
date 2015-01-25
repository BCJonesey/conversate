{div} = React.DOM

Contacts = React.createClass
  displayName: 'Contacts'
  render: ->
    {ContactsToolbar} = Structural.Components

    div {className: 'contacts'},
      ContactsToolbar()

Structural.Components.Contacts = React.createFactory(Contacts)
