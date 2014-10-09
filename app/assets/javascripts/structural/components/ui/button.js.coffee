{a} = React.DOM

Button = React.createClass
  displayName: 'Button'
  render: ->
    klass = @props.className || 'button'
    a {className: klass, onClick: @onClick},
      @props.children

  onClick: (e) ->
    e.preventDefault()

    if @props.onClick
      @props.onClick(e)

    if @props.action
      args = @props.actionArgs || []
      @props.action.apply(null, args)

Structural.Components.Button = Button
