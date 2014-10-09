{SendMessage} = Structural.Actions
{div, textarea} = React.DOM

Compose = React.createClass
  displayName: 'Compose'
  getInitialState: ->
    text: ''
  render: ->
    div {className: 'message-compose-bar'},
      textarea {
        className: 'message-text-input'
        value: @state.text
        onChange: @setText
        onKeyDown: @sendOnEnter
      }
      Structural.Components.PrimaryButton {
        onClick: @sendMessage
      }, "Send"

  setText: (event) ->
    # This function runs after sendOnEnter, and if we don't strip it out,
    # we'll end up appending a stray newline to the input after sending
    # a mesage
    value = event.target.value.replace(/\r?\n/g, '')
    @setState(text: value)

  sendOnEnter: (event) ->
    if event.key == 'Enter'
      @sendMessage()

  sendMessage: ->
    if @state.text != ''
      SendMessage(@props.currentUser, @state.text, @props.conversation)
      @setState(text: '')

Structural.Components.Compose = Compose
