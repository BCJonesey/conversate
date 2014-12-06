IconButton = React.createClass
  displayName: 'Icon Button'
  render: ->
    {Button, Icon} = Structural.Components

    @transferPropsTo(Button({className: 'button-icon'}, Icon({name: @props.icon})))

Structural.Components.IconButton = IconButton
