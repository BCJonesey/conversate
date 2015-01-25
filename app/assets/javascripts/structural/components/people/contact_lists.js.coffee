{div} = React.DOM

ContactLists = React.createClass
  displayName: 'Contact Lists'
  render: ->
    {ContactListsToolbar} = Structural.Components

    div {className: 'contact-lists'},
      ContactListsToolbar()


Structural.Components.ContactLists = React.createFactory(ContactLists)
