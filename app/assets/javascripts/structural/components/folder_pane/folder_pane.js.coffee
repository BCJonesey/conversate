{Folders, ActiveFolder} = Structural.Stores
{div} = React.DOM

FolderPane = React.createClass
  displayName: 'Folder Pane'
  mixins: [
    Folders.listen('folders', Folders.asList)
    ActiveFolder.listen('activeFolder', ActiveFolder.id)
  ]

  render: ->
    div {className: 'folder-pane'},
      Structural.Components.FolderActions()
      Structural.Components.FolderList({
        folders: @state.folders
        activeFolder: @state.activeFolder
      })

Structural.Components.FolderPane = FolderPane
