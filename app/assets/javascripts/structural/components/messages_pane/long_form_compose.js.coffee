{div, textarea} = React.DOM

LongFormCompose = React.createClass
  displayName: 'Long Form Compose'
  render: ->
    {Button, PrimaryButton} = Structural.Components

    div {className: 'long-form-compose'},
      textarea({className: 'long-form-input'}),
      div {className: 'long-form-actions'},
        Button({}, 'Cancel'),
        PrimaryButton({}, 'Send')

Structural.Components.LongFormCompose = LongFormCompose
