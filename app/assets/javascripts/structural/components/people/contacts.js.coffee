{div} = React.DOM

Contacts = React.createClass
  displayName: 'Contacts'
  render: ->
    div {className: 'contacts'}

Structural.Components.Contacts = React.createFactory(Contacts)
