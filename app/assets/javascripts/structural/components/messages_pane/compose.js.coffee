{SendMessage} = Structural.Actions
{div} = React.DOM

Compose = React.createClass
  displayName: 'Compose'
  render: ->
    div {className: 'message-compose-bar'},
      Structural.Components.PrimaryButton {action: SendMessage, actionArgs: [@props.currentUser, 'hello']}, "Send"

Structural.Components.Compose = Compose
