{assert} = Structural.Support

SideEffect = (options) ->
  assert(options.action,
         'SideEffect must register for exactly one action.')
  assert(options.effect,
         'SideEffect must supply exactly one effect to run')

  {action, effect} = options

  if typeof effect == 'string'
    effect = this[effect]
  effect = effect.bind(this)

  id = Structural.Flux.Dispatcher.register(this, action.action, [], effect)
  @dispatcherIdsByAction = {}
  @dispatcherIdsByAction[action.action] = id

  this

Structural.Flux.SideEffect = SideEffect
