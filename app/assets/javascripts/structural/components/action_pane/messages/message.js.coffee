{div} = React.DOM

Message = React.createClass
  displayName: 'Retitle Message View'

  getDefaultProps: -> message: {}

  render: ->
    switch @props.message.type
      when 'retitle' then view = Structural.Components.RetitleMessage
      else view = Structural.Components.RetitleMessage

    view(message: @props.message)


Structural.Components.Message = Message
