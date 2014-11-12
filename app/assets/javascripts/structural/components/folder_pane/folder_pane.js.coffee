{div} = React.DOM

FolderPane = React.createClass
  displayName: 'Folder Pane'
  render: ->
    div {className: 'folder-pane'},
      Structural.Components.FolderActions()

Structural.Components.FolderPane = FolderPane
