{Menu} = Structural.Stores
{div} = React.DOM

MenuLayer = React.createClass
  displayName: 'Menu Layer'
  mixins: [
    Menu.listen('open', Menu.open)
  ]

  render: ->
    if @state.open
      menuClass = "menu #{Menu.direction()}"

      div {className: 'menu-screen', ref: 'screen', onClick: @closeOnClickOff},
        div {className: menuClass, style: Menu.position()},
          div({className: 'menu-pointer'}),
          div({className: 'menu-title'}, Menu.title())
          Menu.content()
          div({className: 'menu-bumper'})
    else
      div {className: 'menu-hidden'}

  closeOnClickOff: (event) ->
    if event.target == @refs.screen.getDOMNode()
      Structural.Actions.CloseMenu()

Structural.Components.MenuLayer = React.createFactory(MenuLayer)
