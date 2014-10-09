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
        onClick: @sendMessage
      }, "Send"

  setText: (event) ->
    value = event.target.value
    if endsWithNewline.test(value)
      @sendMessage()
    else
      @setState(text: value)

  sendMessage: ->
    SendMessage(@props.currentUser, @state.text, @props.conversation)
    @setState(text: '')

Structural.Components.Compose = Compose
