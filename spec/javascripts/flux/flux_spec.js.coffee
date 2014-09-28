describe 'Flux', ->
  beforeEach ->
    @Actions =
      changeName: new Structural.Flux.Action 'changeName',
                                             (name) -> {name: name}
      changeNameViaFn: new Structural.Flux.Action 'changeNameViaFn',
                                                  (name) -> {name: name}
      run: new Structural.Flux.Action 'run', -> {}
      dispatchDuringDispatch:
        new Structural.Flux.Action 'dispatchDuringDispatch', -> {}
      circle: new Structural.Flux.Action 'circle', -> {}
      badPrereq: new Structural.Flux.Action 'badPrereq', -> {}
      effect: new Structural.Flux.Action 'effect', -> {}

    @NameStore = new Structural.Flux.Store
      initialize: ->
        @name = null
      dispatches: [
        {
          action: @Actions.changeName
          callback: (payload) -> @name = payload.name
        }
        {
          action: @Actions.changeNameViaFn
          callback: 'changeNameFn'
        }
      ]
      changeNameFn: (payload) -> @name = payload.name

    @OtherNameStore = new Structural.Flux.Store
      initialize: ->
        @otherName = null
      dispatches: [
        {
          action: @Actions.changeName
          callback: (payload) -> @name = "Other #{payload.name}"
        }
      ]

    @StoreOne = new Structural.Flux.Store
      initialize: ->
        @data = 3
      dispatches: [
        {
          action: @Actions.run
          callback: (payload) -> @data += 1
        }
        {
          action: @Actions.dispatchDuringDispatch
          callback: (payload) ->
            Structural.Flux.Dispatcher.dispatch @Actions.run()
        }
      ]
    StoreOne = @StoreOne

    @StoreTwo = new Structural.Flux.Store
      initialize: ->
        @data = null
      dispatches: [
        {
          action: @Actions.run
          after: [@StoreOne]
          callback: (payload) -> @data = StoreOne.data * StoreOne.data
        }
        {
          action: @Actions.circle
          after: [@StoreOne]
          callback: (payload) ->
        }
        {
          action: @Actions.badPrereq
          after: [@StoreOne]
          callback: (payload) ->
        }
      ]
    StoreTwo = @StoreTwo

    @StoreThree = new Structural.Flux.Store
      initialize: ->
        @data = null
      dispatches: [
        {
          action: @Actions.run
          after: [@StoreOne, @StoreTwo]
          callback: (payload) -> @data = StoreOne.data * StoreTwo.data
        }
        {
          action: @Actions.circle
          after: [@StoreTwo]
          callback: (payload) ->
        }
      ]
    Structural.Flux.Dispatcher.register(
      @StoreOne, @Actions.circle.fluxName, [@StoreThree], ->)

    @StoreWithAPI = new Structural.Flux.Store
      initialize: ->
        @data = {foo: 'Foo'}
      getFoo: ->
        @data.foo

  it 'can send an action to a store', ->
    @Actions.changeName('Alice')

    expect(@NameStore.name).toBe('Alice')

  it 'can send an action to a store via named function', ->
    @Actions.changeName('Bob')

    expect(@NameStore.name).toBe('Bob')

  it 'can send an action to multiple stores', ->
    @Actions.changeName('Charlie')

    expect(@NameStore.name).toBe('Charlie')
    expect(@OtherNameStore.name).toBe('Other Charlie')

  it 'can have one store wait for another', ->
    @Actions.run()

    expect(@StoreOne.data).toBe(4)
    expect(@StoreTwo.data).toBe(16)
    expect(@StoreThree.data).toBe(64)

  it 'can send an action to a side effect', ->
    effected = false
    MyEffect = new Structural.Flux.SideEffect
      action: @Actions.effect
      effect: (payload) -> effected = true

    @Actions.effect()

    expect(effected).toBe(true)

  it 'can send an action in two steps.', ->
    payload = @Actions.changeName.buildPayload('Dave')
    @Actions.changeName.send(payload)

    expect(@NameStore.name).toBe('Dave')

  it 'can call other functions on a store', ->
    expect(@StoreWithAPI.getFoo()).toBe('Foo')

  it 'fails when store prerequisites have a circular dependency', ->
    sendCircularDep = -> @Actions.circle()

    expect(sendCircularDep).toThrow()

  it 'fails when prerequisite store does not handle action', ->
    sendBadPrereq = -> @Actions.badPrereq()

    expect(sendBadPrereq).toThrow()

  it 'fails when dispatching during dispatch', ->
    sendDispatchDuringDispatch = -> @Actions.dispatchDuringDispatch()

    expect(sendDispatchDuringDispatch).toThrow()

  it 'fails when creating a side effect with no action', ->
    makeBadSideEffect = ->
      new Structural.Flux.SideEffect
        effect: (payload) ->

    expect(makeBadSideEffect).toThrow()

  it 'fails when creating a side effect with no effect', ->
    makeBadSideEffect = ->
      new Structural.Flux.SideEffect
        action: @Actions.effect

    expect(makeBadSideEffect).toThrow()
