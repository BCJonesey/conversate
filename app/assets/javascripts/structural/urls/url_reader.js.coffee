UrlReader = {
  read: (url) ->
    if url[0] == '/'
      url = url.substring(1)

    segments = url.split('/')

    if segments[0] == 'folder'
      return {
        type: 'folder'
        slug: segments[1]
        id: Number(segments[2])
      }
    else if segments[0] == 'conversation'
      return {
        type: 'conversation'
        slug: segments[1]
        id: Number(segments[2])
      }
    else
      return {
        type: '404'
        segments: segments
      }
}

Structural.Urls.UrlReader = UrlReader
