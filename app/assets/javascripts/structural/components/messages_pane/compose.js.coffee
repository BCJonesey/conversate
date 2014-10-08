{SendMessage} = Structural.Actions
{div, textarea} = React.DOM

endsWithNewline = /\n$/

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
    value = event.target.value
    if endsWithNewline.test(value)
      text = value.substr(0, value.length - 1)
      SendMessage(@props.currentUser, text, @props.conversation)
    else
      @setState
        text: value

Structural.Components.Compose = Compose
