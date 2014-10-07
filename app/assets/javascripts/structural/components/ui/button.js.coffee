{a} = React.DOM

Button = React.createClass
  displayName: 'Button'
  render: ->
    a {className: 'button', onClick: @onClick},
      @props.children

  onClick: (e) ->
    e.preventDefault()

    if @props.action
      args = @props.actionArgs || []
      @props.action.apply(null, args)

Structural.Components.Button = Button
