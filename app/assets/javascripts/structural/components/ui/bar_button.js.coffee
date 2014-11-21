BarButton = React.createClass
  displayName: 'Bar Button'
  render: ->
    {Button, Icon} = Structural.Components

    klass = if @props.active then 'button-stb-active' else 'button-stb'
    icon = if @props.icon then Icon({name: @props.icon}) else undefined

    @transferPropsTo(Button({className: klass}, icon, @props.children))

Structural.Components.BarButton = BarButton
