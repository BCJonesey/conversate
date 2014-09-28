Action = (name, ctor) ->
  buildPayload = ->
    payload = ctor.apply(null, arguments)
    payload.action = name
    payload

  send = (payload) ->
    Structural.Flux.Dispatcher.dispatch(payload)

  actionFn = ->
    payload = buildPayload.apply(null, arguments)
    send(payload)

  actionFn.buildPayload = buildPayload
  actionFn.send = send

  actionFn.action = name
  actionFn.toString = -> name

  actionFn

Structural.Flux.Action = Action
