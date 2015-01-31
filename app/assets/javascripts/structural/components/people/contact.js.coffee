{name} = Structural.Data.Participant
{div, span} = React.DOM

Contact = React.createClass
  displayName: 'Contact'
  render: ->
    div {className: 'contact'},
      span({className: 'name'}, name(@props.contact.user))
      span({className: 'email'}, @props.contact.user.email)

Structural.Components.Contact = React.createFactory(Contact)
