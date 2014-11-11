slugify = (s) ->
  encodeURIComponent(s.toLowerCase()
                      .replace(/[ _]/g, '-')
                      .replace(/[^A-Za-z0-9-]/g, ''))

Structural.UrlFactory = {
  conversation: (conversation) ->
    "/conversation/#{slugify(conversation.title)}/#{conversation.id}"
}
