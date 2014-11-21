{a} = React.DOM

Button = React.createClass
  displayName: 'Button'
  render: ->
    klass = @props.className || 'button'
    a {className: klass, onClick: @onClick, href: @props.href},
      @props.children

  onClick: (e) ->
    if @props.onClick
      e.preventDefault()
      @props.onClick(e)

    if @props.action
      e.preventDefault()
      args = @props.actionArgs || []
      @props.action.apply(null, args)

Structural.Components.Button = Button
