Message = {
  isMessageType: (message) ->
    message.type in ['message', 'email_message', 'upload_message']
}

Structural.Data.Message = Message
