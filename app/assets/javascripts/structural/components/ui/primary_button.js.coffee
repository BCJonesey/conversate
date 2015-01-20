PrimaryButton = React.createClass
  displayName: 'Primary Button'
  render: ->
    props = _.assign(@props, 'button-primary')
    Structural.Components.Button(props, @props.children)

Structural.Components.PrimaryButton = React.createFactory(PrimaryButton)
