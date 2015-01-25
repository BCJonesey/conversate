{UrlFactory} = Structural.Urls
{UpdateActiveContactList} = Structural.Actions
{div, a} = React.DOM

ContactList = React.createClass
  displayName: 'Contact List'
  render: ->
    {Icon} = Structural.Components

    klass = 'contact-list'
    if @props.activeListId == @props.contactList.id
      klass = "#{klass} active-contact-list"

    url = UrlFactory.contactList(@props.contactList)

    a {className: klass, href: url, onClick: @onClick},
      @props.contactList.name
      Icon({name: 'info-circle', className: 'contact-list-info'})

  onClick: (event) ->
    if event.button == 0
      event.preventDefault()
      if @props.activeListId != @props.contactList.id
        UpdateActiveContactList(@props.contactList.id)

Structural.Components.ContactList = React.createFactory(ContactList)
