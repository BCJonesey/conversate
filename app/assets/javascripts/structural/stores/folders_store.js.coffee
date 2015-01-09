{hashToSortedArray} = Structural.Data.Collection

Folders = Hippodrome.createStore
  displayName: 'Folders Store'
  initialize: ->
    @folders = {}

    @dispatch(Structural.Actions.UpdateFolderList).to(@updateFolderList)

  updateFolderList: (payload) ->
    @folders = payload.folders
    @trigger()

  public:
    byId: (id) ->
      @folders[id]
    asList: ->
      hashToSortedArray(@folders, 'id')

Structural.Stores.Folders = Folders
