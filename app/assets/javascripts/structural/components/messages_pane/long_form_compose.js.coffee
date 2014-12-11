{CloseModal, SendMessage} = Structural.Actions
{div, textarea} = React.DOM

LongFormCompose = React.createClass
  displayName: 'Long Form Compose'
  getInitialState: ->
    text: @props.text
  render: ->
    {Button, PrimaryButton} = Structural.Components

    div {className: 'long-form-compose'},
      textarea({
        className: 'long-form-input'
        value: @state.text
        onChange: @setText
      }),
      div {className: 'long-form-actions'},
        Button({action: CloseModal}, 'Cancel'),
        PrimaryButton({onClick: @sendAndClose}, 'Send')

  setText: (event) ->
    @setState(text: event.target.value)

  sendAndClose: (event) ->
    if @state.text != ''
      SendMessage(@props.currentUser, @state.text, @props.conversation)
      CloseModal()
      @props.afterSend()

Structural.Components.LongFormCompose = LongFormCompose
