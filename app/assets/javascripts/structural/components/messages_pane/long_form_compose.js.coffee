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
        Button({}, 'Cancel'),
        PrimaryButton({}, 'Send')

  setText: (event) ->
    @setState(text: value)

Structural.Components.LongFormCompose = LongFormCompose
