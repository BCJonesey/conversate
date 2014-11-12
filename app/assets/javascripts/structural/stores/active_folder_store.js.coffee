ActiveFolder = new Hippodrome.Store
  displayName: 'Active Folder Store'
  initialize: ->
    @activeFolderId = null
  dispatches: [{
    action: Structural.Actions.UpdateActiveFolder
    callback: 'updateActiveFolderId'
  }]
  updateActiveFolderId: (payload) ->
    @activeFolderId = payload.activeFolderId
    @trigger()

  public:
    id: -> @activeFolderId

Structural.Stores.ActiveFolder = ActiveFolder
