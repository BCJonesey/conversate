{div} = React.DOM

RetitleMessage = React.createClass
  displayName: 'Retitle Message View'

  getDefaultProps: -> message: {}

  render: ->
    message = @props.message
    div className: 'message retitle-message',
      message.title

Structural.Components.RetitleMessage = RetitleMessage
