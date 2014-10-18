#= require_self
#= require_tree .

Api = {
  apiPrefix: "/api/v0"
  post: (urlFn) ->
    (data, urlArgs..., success, error) ->
      urlArgs.splice(0, 0, data)
      url = urlFn.apply(null, urlArgs)
      Structural.Http.post(url, data, success, error)

  put: (urlFn) ->
    (data, urlArgs..., success, error) ->
      urlArgs.splice(0, 0, data)
      url = urlFn.apply(null, urlArgs)
      Structural.Http.put(url, data, success, error)

  get: (urlFn) ->
    (urlArgs..., success, error) ->
      url = urlFn.apply(null, urlArgs)
      Structural.Http.get(url, success, error)
}

Structural.Api = Api
