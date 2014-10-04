{div} = React.DOM

FolderPane = React.createClass
  displayName: 'Folder Pane'
  render: ->
    div {className: 'folder-pane'}

Structural.Components.FolderPane = FolderPane
