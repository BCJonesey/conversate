{SendMessage} = Structural.Actions
{div, textarea} = React.DOM

Compose = React.createClass
  displayName: 'Compose'
  getInitialState: ->
    text: ''
  render: ->
    if @state.text == ''
      action = undefined
    else
      action = SendMessage

    div {className: 'message-compose-bar'},
      textarea {
        className: 'message-text-input'
        value: @state.text
        onChange: @setText
      }
      Structural.Components.PrimaryButton {
        action: action
        actionArgs: [@props.currentUser, @state.text, @props.conversation]
      }, "Send"

  setText: (event) ->
    @setState
      text: event.target.value

Structural.Components.Compose = Compose
