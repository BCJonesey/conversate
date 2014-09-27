{div} = React.DOM

FolderPane = React.createClass
  displayName: 'Folder Pane'
  render: ->
    div {className: 'ui-section fld-container'}

Structural.Components.FolderPane = FolderPane
