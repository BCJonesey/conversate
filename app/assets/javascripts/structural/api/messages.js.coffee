Messages = {
  index: Structural.Api.get((conversation) ->
    Structural.UrlFactory.Api.conversationMessages(conversation))
  newMessage: Structural.Api.post((message, conversation) ->
    Structural.UrlFactory.Api.conversationMessages(conversation))
}

Structural.Api.Messages = Messages
