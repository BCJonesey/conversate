IconButton = React.createClass
  displayName: 'Icon Button'
  render: ->
    {Button, Icon} = Structural.Components

    props = _.assign(@props, {className: 'button-icon'})
    Button(props, Icon({name: @props.icon}))

Structural.Components.IconButton = React.createFactory(IconButton)
