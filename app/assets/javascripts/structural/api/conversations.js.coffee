Conversations = {
  updateMostRecentViewed: Structural.Api.put((conversation, user) ->
    "#{Structural.Api.apiPrefix}/conversations/#{conversation.id}/participants/#{user.id}")
}

Structural.Api.Conversations = Conversations
