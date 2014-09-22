{assert} = Structural.Support

Store = (options) ->
  @dispatcherIdsByAction = {}
  @callbacks = []
  _.assign(@, _.omit(options, 'initialize', 'dispatches'))

  if options.initialize
    options.initialize.call(@)

  if options.dispatches
    _.forEach(options.dispatches, (callbackSpec, action) =>
      assert(not @dispatcherIdsByAction[action]
             'Each store can only register one callback for each action.')

      callback = callbackSpec
      if callbackSpec instanceof Array
        [stores..., callback] = callbackSpec

      if typeof callback == 'string'
        callback = @[callback]
      callback = callback.bind(@)

      id = Structural.Flux.Dispatcher.register(@, action, stores, callback)
      @dispatcherIdsByAction[action] = id
    )

  @

Store.prototype.listen = (callback) ->
  @callbacks.push(callback)

Store.prototype.ignore = (callback) ->
  @callbacks = _.reject(@callbacks, (cb) -> cb == callback)

Store.prototype.trigger = ->
  _.forEach(@callbacks, (callback) -> callback())

Structural.Flux.Store = Store
