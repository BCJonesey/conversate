{assert} = Structural.Support

Store = (options) ->
  @dispatcherIdsByAction = {}
  @callbacks = []
  _.assign(@, _.omit(options, 'initialize', 'dispatches'))

  if options.initialize
    options.initialize.call(@)

  if options.dispatches
    _.forEach(options.dispatches, (callbackDescription) =>
      {action, after, callback} = callbackDescription

      assert(not @dispatcherIdsByAction[action.fluxName]
             'Each store can only register one callback for each action.')

      if typeof callback == 'string'
        callback = @[callback]
      callback = callback.bind(@)

      id = Structural.Flux.Dispatcher.register(this, action.fluxName, after, callback)
      @dispatcherIdsByAction[action.fluxName] = id
    )

  this

Store.prototype.listen = (callback) ->
  @callbacks.push(callback)

Store.prototype.ignore = (callback) ->
  @callbacks = _.reject(@callbacks, (cb) -> cb == callback)

Store.prototype.trigger = ->
  _.forEach(@callbacks, (callback) -> callback())

Structural.Flux.Store = Store
