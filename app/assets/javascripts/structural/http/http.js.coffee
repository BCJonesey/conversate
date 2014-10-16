# Assume there's only one CSRF token.  If there's more than one, we're
# probably more screwed than this script can handle anyway.
authenticityToken = document.getElementsByName('csrf-token')[0].content

Http = {
  request: (method, url, data, success, error) ->
    xhr = new XMLHttpRequest()
    xhr.open(method, url)
    xhr.responseType = 'json'
    xhr.setRequestHeader('Accept', 'application/json, text/javascript, */*; q=0.01')
    xhr.setRequestHeader('Content-Type', 'application/json')
    xhr.setRequestHeader('X-CSRF-Token', authenticityToken)

    xhr.onreadystatechange = (xhrEvent) ->
      if xhr.readyState == 4
        successful = xhr.status < 400
        if successful
          success(xhr.response)
        else
          error(xhr.response, xhr.status)

    xhr.send(JSON.stringify(data))

  post: (url, data, success, error) ->
    Http.request('post', url, data, success, error)

  get: (url, success, error) ->
    Http.request('get', url, undefined, success, error)
}

Structural.Http = Http
