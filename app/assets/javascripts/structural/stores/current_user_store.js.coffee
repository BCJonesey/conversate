CurrentUser = Hippodrome.createStore
  initialize: ->
    @user = null

    @dispatch(Structural.Actions.UpdateCurrentUser).to(@updateCurrentUser)

  updateCurrentUser: (payload) ->
    @user = payload.user
    @trigger()

  public:
    getUser: -> @user

Structural.Stores.CurrentUser = CurrentUser
