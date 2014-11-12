{hashToSortedArray} = Structural.Data.Collection

Folders = new Hippodrome.Store
  displayName: 'Folders Store'
  initialize: ->
    @folders = {}
  dispatches: [{
    action: Structural.Actions.UpdateFolderList
    callback: 'updateFolderList'
  }]

  updateFolderList: (payload) ->
    @folders = payload.folders
    @trigger()

  public:
    byId: (id) ->
      @folders[id]
    asList: ->
      hashToSortedArray(@folders, 'id')

Structural.Stores.Folders = Folders
