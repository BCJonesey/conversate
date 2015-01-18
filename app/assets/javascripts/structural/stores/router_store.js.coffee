Router = Hippodrome.createStore
  displayName: 'Router'
  initialize: ->
    @_view = undefined

    @dispatch(Structural.Actions.UpdateActiveContactList).to(@viewPeople)
    @dispatch(Structural.Actions.UpdateActiveFolder).to(@viewWatercooler)
    @dispatch(Structural.Actions.UpdateActiveConversation).to(@viewWatercooler)

  viewPeople: (payload) ->
    @_view = 'people'
    @trigger()

  viewWatercooler: (payload) ->
    @_view = 'watercooler'
    @trigger()

  public:
    view: () -> @_view

Structural.Stores.Router = Router
