slugify = (s) ->
  encodeURIComponent(s.toLowerCase()
                      .replace(/[ _]/g, '-')
                      .replace(/[^A-Za-z0-9-]/g, ''))

UrlFactory = {
  conversation: (conversation) ->
    "/conversation/#{slugify(conversation.title)}/#{conversation.id}"

  Api: {
    _apiUrl: (suffix) -> "/api/v0#{suffix}"
    conversationMessages: (conversation) ->
      UrlFactory.Api._apiUrl("/conversations/#{conversation.id}/actions")
    conversationParticipants: (conversation, user) ->
      UrlFactory.Api._apiUrl("/conversations/#{conversation.id}/participants/#{user.id}")
  }
}

Structural.UrlFactory = UrlFactory
