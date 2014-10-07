PrimaryButton = React.createClass
  displayName: 'Primary Button'
  render: ->
    @transferPropsTo(
      Structural.Components.Button({className: 'button-primary'}, @props.children))

Structural.Components.PrimaryButton = PrimaryButton
