{Menu} = Structural.Stores
{OpenMenu, ReplaceMenuContent} = Structural.Actions
{span} = React.DOM

MenuTrigger = React.createClass
  displayName: 'Menu Trigger'
  mixins: [
    Menu.listenWith('menuUpdate')
  ]

  menuUpdate: ->
    return {
      open: Menu.open()
      active: @state and @state.active and Menu.open()
    }

  componentDidUpdate: (prevProps, prevState) ->
    if @state.active
      _.defer(() => ReplaceMenuContent(@props.content, @props.title, @getDOMNode()))
  render: ->
    className = "#{@props.className} #{if @state.active then 'active-trigger' else ''}"
    span {className: className, onClick: @onClick}, @props.children

  onClick: ->
    OpenMenu(@props.content, @props.title, @getDOMNode())
    @setState(active: true)

Structural.Components.MenuTrigger = MenuTrigger
