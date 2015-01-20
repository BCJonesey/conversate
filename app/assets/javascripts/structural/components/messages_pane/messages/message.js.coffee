{div} = React.DOM

Message = React.createClass
  displayName: 'Abstract Message'

  getDefaultProps: -> message: {}

  render: ->
    viewTypes =
      email_delivery_error: Structural.Components.EmailDeliveryErrorMessage
      email_message: Structural.Components.MessageMessage
      message: Structural.Components.MessageMessage
      retitle: Structural.Components.RetitleMessage
      update_users: Structural.Components.UpdateUsersMessage
      update_viewers: Structural.Components.UpdateViewersMessage
      upload_message: Structural.Components.MessageMessage

    if @props.message.type of viewTypes
      view = viewTypes[@props.message.type]
    else
      view = Structural.Components.UnknownMessage

    view {
      message: @props.message
      currentUser: @props.currentUser
      conversation: @props.conversation
      folder: @props.folder
    }

Structural.Components.Message = React.createFactory(Message)
