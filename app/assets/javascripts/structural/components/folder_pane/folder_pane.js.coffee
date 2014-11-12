{Folders, ActiveFolder} = Structural.Stores
{div} = React.DOM

FolderPane = React.createClass
  displayName: 'Folder Pane'
  mixins: [
    Folders.listen('updateFolders')
    ActiveFolder.listen('updateActiveFolder')
  ]
  getInitialState: ->
    folders: Folders.asList()
    activeFolder: ActiveFolder.id()
  updateFolders: ->
    @setState(folders: Folders.asList())
  updateActiveFolder: ->
    @setState(activeFolder: ActiveFolder.id())

  render: ->
    div {className: 'folder-pane'},
      Structural.Components.FolderActions()
      Structural.Components.FolderList({
        folders: @state.folders
        activeFolder: @state.activeFolder
      })

Structural.Components.FolderPane = FolderPane
