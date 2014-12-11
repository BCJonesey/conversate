{Menu} = Structural.Stores
{span} = React.DOM

MenuTrigger = React.createClass
  displayName: 'Menu Trigger'
  mixins: [
    Menu.listen('menuUpdate')
  ]
  getInitialState: ->
    active: false
    open: Menu.open()
  menuUpdate: ->
    @setState(open: Menu.open(), active: @state.active and Menu.open())
  render: ->
    className = "#{@props.className} #{if @state.active then 'active-trigger' else ''}"
    span {className: className, onClick: @onClick}, @props.children

  onClick: ->
    Structural.Actions.OpenMenu(@props.content, @props.title, @getDOMNode())
    @setState(active: true)

Structural.Components.MenuTrigger = MenuTrigger
