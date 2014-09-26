describe 'Flux', ->
  beforeEach ->
    @Actions =
      changeName: new Structural.Flux.Action (name) -> {name: name}
      changeNameViaFn: new Structural.Flux.Action (name) -> {name: name}
      run: new Structural.Flux.Action -> {}
      dispatchDuringDispatch: new Structural.Flux.Action -> {}
      circle: new Structural.Flux.Action -> {}
      badPrereq: new Structural.Flux.Action -> {}

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
      @StoreOne, @Actions.circle.action, [@StoreThree], ->)

  it 'can send an action to a store', ->
    Structural.Flux.Dispatcher.dispatch @Actions.changeName('Alice')

    expect(@NameStore.name).toBe('Alice')

  it 'can send an action to a store via named function', ->
    Structural.Flux.Dispatcher.dispatch @Actions.changeName('Bob')

    expect(@NameStore.name).toBe('Bob')

  it 'can send an action to multiple stores', ->
    Structural.Flux.Dispatcher.dispatch @Actions.changeName('Charlie')

    expect(@NameStore.name).toBe('Charlie')
    expect(@OtherNameStore.name).toBe('Other Charlie')

  it 'can have one store wait for another', ->
    Structural.Flux.Dispatcher.dispatch @Actions.run()

    expect(@StoreOne.data).toBe(4)
    expect(@StoreTwo.data).toBe(16)
    expect(@StoreThree.data).toBe(64)

  it 'fails when store prerequisites have a circular dependency', ->
    sendCircularDep = ->
      Structural.Flux.Dispatcher.dispatch @Actions.circle()

    expect(sendCircularDep).toThrow()

  it 'fails when prerequisite store does not handle action', ->
    sendBadPrereq = ->
      Structural.Flux.Dispatcher.dispatch @Actions.badPrereq()

    expect(sendBadPrereq).toThrow()

  it 'fails when dispatching during dispatch', ->
    sendDispatchDuringDispatch = ->
      Structural.Flux.Dispatcher.dispatch @Actions.dispatchDuringDispatch()

    expect(sendDispatchDuringDispatch).toThrow()
