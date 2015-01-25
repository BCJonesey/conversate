{div} = React.DOM

ContactLists = React.createClass
  displayName: 'Contact Lists'
  render: ->
    div {className: 'contact-lists'}

Structural.Components.ContactLists = React.createFactory(ContactLists)
