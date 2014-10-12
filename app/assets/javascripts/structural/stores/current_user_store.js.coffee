CurrentUser = new Hippodrome.Store
  initialize: ->
    @user = null

  dispatches: [
    {
      action: Structural.Actions.UpdateCurrentUser
      callback: 'updateCurrentUser'
    }
  ]

  updateCurrentUser: (payload) ->
    @user = payload.user
    @trigger()

  getUser: ->
    @user

Structural.Stores.CurrentUser = CurrentUser
