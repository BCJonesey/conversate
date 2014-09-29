{div} = React.DOM

Message = React.createClass
  displayName: 'Abstract Message'

  getDefaultProps: -> message: {}

  render: ->
    switch @props.message.type
      when 'retitle' then view = Structural.Components.RetitleMessage
      else view = Structural.Components.UnknownMessage

    view(message: @props.message)


Structural.Components.Message = Message
