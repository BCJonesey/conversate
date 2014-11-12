{Folders} = Structural.Stores
{div} = React.DOM

FolderPane = React.createClass
  displayName: 'Folder Pane'
  mixins: [
    Folders.listen('updateFolders')
  ]
  getInitialState: ->
    folders: Folders.asList()
  updateFolders: ->
    @setState(folders: Folders.asList())

  render: ->
    div {className: 'folder-pane'},
      Structural.Components.FolderActions()
      Structural.Components.FolderList({folders: @state.folders})

Structural.Components.FolderPane = FolderPane
