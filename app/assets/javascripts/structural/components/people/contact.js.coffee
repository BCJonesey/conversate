{name} = Structural.Data.Participant
{div} = React.DOM

Contact = React.createClass
  displayName: 'Contact'
  render: ->
    div {className: 'contact'}, name(@props.contact.user)

Structural.Components.Contact = React.createFactory(Contact)
