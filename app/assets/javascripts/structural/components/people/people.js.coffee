{div} = React.DOM

People = React.createClass
  displayName: 'People'
  render: ->
    div {className: 'people'},
      Structural.Components.ContactListsPane()
      Structural.Components.ContactsPane()

Structural.Components.People = React.createFactory(People)
