{div} = React.DOM

ContactListsToolbar = React.createClass
  displayName: 'Contact Lists Toolbar'
  render: ->
    div {className: 'contact-lists-toolbar'}

Structural.Components.ContactListsToolbar =
  React.createFactory(ContactListsToolbar)
