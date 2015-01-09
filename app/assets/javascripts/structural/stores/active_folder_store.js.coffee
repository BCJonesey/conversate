ActiveFolder = Hippodrome.createStore
  displayName: 'Active Folder Store'
  initialize: ->
    @activeFolderId = null

    @dispatch(Structural.Actions.UpdateActiveFolder).to(@updateActiveFolderId)

  updateActiveFolderId: (payload) ->
    @activeFolderId = Number(payload.activeFolderId)
    @trigger()

  public:
    id: -> @activeFolderId

Structural.Stores.ActiveFolder = ActiveFolder
