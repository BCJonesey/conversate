Messages = {
  index: Structural.Api.get((conversation) ->
    "#{Structural.Api.apiPrefix}/conversations/#{conversation.id}/actions")
  newMessage: Structural.Api.post((message, conversation) ->
    "#{Structural.Api.apiPrefix}/conversations/#{conversation.id}/actions")
}

Structural.Api.Messages = Messages
