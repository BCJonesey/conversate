{div} = React.DOM

ContactList = React.createClass
  displayName: 'Contact List'
  render: ->
    {Icon} = Structural.Components

    div {className: 'contact-list'}, @props.contactList.name,
      Icon({name: 'info-circle', className: 'contact-list-info'})

Structural.Components.ContactList = React.createFactory(ContactList)
