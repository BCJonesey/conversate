describe 'Stores and Dispatchers', ->
  beforeEach ->
    @NameStore = new Structural.Flux.Store
      initialize: ->
        @name = null
      dispatches:
        'changeName': (payload) -> @name = payload.name
        'changeNameViaFn': 'changeNameFn'
      changeNameFn: (payload) -> @name = payload.name

    @OtherNameStore = new Structural.Flux.Store
      initialize: ->
        @otherName = null
      dispatches:
        'changeName': (payload) -> @name = 'Other ' + payload.name

    @StoreOne = new Structural.Flux.Store
      initialize: ->
        @data = 3
      dispatches:
        'run': (payload) -> @data += 1
        'dispatchDuringDispatch': (payload) ->
          Structural.Flux.Dispatcher.dispatch
            action: 'run'
    StoreOne = @StoreOne

    @StoreTwo = new Structural.Flux.Store
      initialize: ->
        @data = null
      dispatches:
        'run': [
          @StoreOne
          (payload) -> @data = StoreOne.data * StoreOne.data
        ]
        'circle': [
          @StoreOne
          (payload) ->
        ]
        'badPrereq': [
          @StoreOne
          (payload) ->
        ]
    StoreTwo = @StoreTwo

    @StoreThree = new Structural.Flux.Store
      initialize: ->
        @data = null
      dispatches:
        'run': [
          @StoreOne
          @StoreTwo
          (payload) -> @data = StoreOne.data * StoreTwo.data
        ]
        'circle': [
          @StoreTwo
          (payload) ->
        ]
    Structural.Flux.Dispatcher.register(@StoreOne, 'circle', [@StoreThree], ->)

  it 'can send an action to a store', ->
    Structural.Flux.Dispatcher.dispatch
      action: 'changeName'
      name: 'Alice'

    expect(@NameStore.name).toBe('Alice')

  it 'can send an action to a store via named function', ->
    Structural.Flux.Dispatcher.dispatch
      action: 'changeNameViaFn'
      name: 'Bob'

    expect(@NameStore.name).toBe('Bob')

  it 'can send an action to multiple stores', ->
    Structural.Flux.Dispatcher.dispatch
      action: 'changeName'
      name: 'Charlie'

    expect(@NameStore.name).toBe('Charlie')
    expect(@OtherNameStore.name).toBe('Other Charlie')

  it 'can have one store wait for another', ->
    Structural.Flux.Dispatcher.dispatch
      action: 'run'

    expect(@StoreOne.data).toBe(4)
    expect(@StoreTwo.data).toBe(16)
    expect(@StoreThree.data).toBe(64)

  it 'fail when store prerequisites have a circular dependency', ->
    sendCircularDep = ->
      Structural.Flux.Dispatcher.dispatch
        action: 'circle'

    expect(sendCircularDep).toThrow()

  it 'fail when prerequisite store does not handle action', ->
    sendBadPrereq = ->
      Structural.Flux.Dispatcher.dispatch
        action: 'badPrereq'

    expect(sendBadPrereq).toThrow()

  it 'fail when dispatching during dispatch', ->
    sendDispatchDuringDispatch = ->
      Structural.Flux.Dispatcher.dispatch
        action: 'dispatchDuringDispatch'

    expect(sendDispatchDuringDispatch).toThrow()
