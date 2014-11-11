Conversations = {
  updateMostRecentViewed: Structural.Api.put((conversation, user) ->
    Structural.UrlFactory.Api.conversationParticipants(conversation, user))
}

Structural.Api.Conversations = Conversations
