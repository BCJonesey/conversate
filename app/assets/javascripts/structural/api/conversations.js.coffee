Conversations = {
  index: Structural.Api.get((folder) ->
    Structural.UrlFactory.Api.folderConversations(folder))
  updateMostRecentViewed: Structural.Api.put((conversation, user) ->
    Structural.UrlFactory.Api.conversationParticipants(conversation, user))
}

Structural.Api.Conversations = Conversations
