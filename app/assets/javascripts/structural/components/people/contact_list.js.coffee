{div} = React.DOM

ContactList = React.createClass
  displayName: 'Contact List'
  render: ->
    {Icon} = Structural.Components

    klass = 'contact-list'
    if @props.activeListId == @props.contactList.id
      klass = "#{klass} active-contact-list"

    div {className: klass}, @props.contactList.name,
      Icon({name: 'info-circle', className: 'contact-list-info'})

Structural.Components.ContactList = React.createFactory(ContactList)
