{SendMessage} = Structural.Actions
{div, textarea} = React.DOM

Compose = React.createClass
  displayName: 'Compose'
  getInitialState: ->
    text: ''
  render: ->
    {LongFormCompose, ModalTrigger, MenuTrigger, IconButton,
     PrimaryButton} = Structural.Components

    div {className: 'message-compose-bar'},
      ModalTrigger({
        className: 'long-form-trigger'
        content: LongFormCompose({
          text: @state.text
          currentUser: @props.currentUser
          conversation: @props.conversation
          afterSend: @clearText
        })
        title: if @props.conversation then @props.conversation.title else ''
      }, IconButton({icon: 'edit'}))
      MenuTrigger({
        className: 'upload-trigger'
        content: 'Upload TBD',
        title: 'Upload a File'
      }, IconButton({icon: 'paperclip'}))
      textarea {
        className: 'message-text-input'
        value: @state.text
        onChange: @setText
        onKeyDown: @sendOnEnter
      }
      PrimaryButton {
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
      @clearText()

  clearText: ->
    @setState(text: '')

Structural.Components.Compose = Compose
