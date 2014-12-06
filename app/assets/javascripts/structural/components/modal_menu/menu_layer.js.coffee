{Menu} = Structural.Stores
{div} = React.DOM

MenuLayer = React.createClass
  displayName: 'Menu Layer'
  mixins: [
    Menu.listen('updateMenu')
  ]
  getInitialState: ->
    open: Menu.open()
  updateMenu: ->
    @setState(open: Menu.open())

  render: ->
    if @state.open
      div {className: 'menu-screen', ref: 'screen', onClick: @closeOnClickOff},
        div {className: 'menu', style: Menu.position()},
          Menu.content()
    else
      div {className: 'menu-hidden'}

Structural.Components.MenuLayer = MenuLayer
