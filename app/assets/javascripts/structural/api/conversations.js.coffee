{UrlFactory} = Structural.Urls

Conversations = {
  index: Structural.Api.get((folder) ->
    UrlFactory.Api.folderConversations(folder))
  updateMostRecentViewed: Structural.Api.put((conversation, user) ->
    UrlFactory.Api.conversationParticipants(conversation, user))
  pinUnpin: Structural.Api.put((conversation, user) ->
    UrlFactory.Api.conversationParticipants(conversation, user))
}

Structural.Api.Conversations = Conversations
