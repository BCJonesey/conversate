prefix = 'Action_ID_'
lastId = 1
nextId = -> prefix + lastId++

Action = (ctor) ->
  id = nextId()
  fn = ->
    payload = ctor.apply(null, arguments)
    payload.action = id
    payload

  fn.action = id
  fn.prototype.toString = -> id

  fn

Structural.Flux.Action = Action
