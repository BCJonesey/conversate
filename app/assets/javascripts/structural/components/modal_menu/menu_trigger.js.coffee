{span} = React.DOM

MenuTrigger = React.createClass
  displayName: 'Menu Trigger'
  render: ->
    span {className: @props.className, onClick: @onClick}, @props.children}

  onClick: ->
    Structural.Actions.OpenMenu(@props.content, @getDOMNode())

Structural.Components.MenuTrigger = MenuTrigger
