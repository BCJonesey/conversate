{UrlFactory} = Structural.Urls

Conversations = {
  index: Structural.Api.get((folder) ->
    UrlFactory.Api.folderConversations(folder))
  updateConversationForUser: Structural.Api.put((conversation, user) ->
      UrlFactory.Api.conversationParticipants(conversation, user))
}

Structural.Api.Conversations = Conversations
