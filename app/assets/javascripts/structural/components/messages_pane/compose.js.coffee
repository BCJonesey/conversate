{SendMessage} = Structural.Actions
{div, textarea} = React.DOM

Compose = React.createClass
  displayName: 'Compose'
  getInitialState: ->
    text: ''
  render: ->
    div {className: 'message-compose-bar'},
      textarea {className: 'message-text-input', value: @state.text, onChange: @setText}
      Structural.Components.PrimaryButton {action: SendMessage, actionArgs: [@props.currentUser, @state.text, @props.conversation]}, "Send"
  setText: (event) ->
    @setState
      text: event.target.value

Structural.Components.Compose = Compose
