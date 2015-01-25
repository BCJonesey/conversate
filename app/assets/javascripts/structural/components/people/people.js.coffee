{div} = React.DOM

People = React.createClass
  displayName: 'People'
  render: ->
    div {className: 'people'},
      Structural.Components.ContactLists()
      Structural.Components.Contacts()

Structural.Components.People = React.createFactory(People)
