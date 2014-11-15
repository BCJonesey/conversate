{UrlFactory} = Structural.Urls

Messages = {
  index: Structural.Api.get((conversation) ->
    UrlFactory.Api.conversationMessages(conversation))
  newMessage: Structural.Api.post((message, conversation) ->
    UrlFactory.Api.conversationMessages(conversation))
}

Structural.Api.Messages = Messages
