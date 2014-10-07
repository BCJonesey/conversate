{div} = React.DOM

Compose = React.createClass
  displayName: 'Compose'
  render: ->
    div {className: 'message-compose-bar'},
      Structural.Components.PrimaryButton {}, "Send"

Structural.Components.Compose = Compose
