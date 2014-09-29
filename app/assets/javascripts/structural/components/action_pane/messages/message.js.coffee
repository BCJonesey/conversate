{div} = React.DOM

Message = React.createClass
  displayName: 'Abstract Message'

  getDefaultProps: -> message: {}

  render: ->
    viewTypes =
      retitle: Structural.Components.RetitleMessage
      update_users: Structural.Components.UpdateUsersMessage

    if @props.message.type of viewTypes
      view = viewTypes[@props.message.type]
    else
      view = Structural.Components.UnknownMessage

    view(message: @props.message)

Structural.Components.Message = Message
