{isShared} = Structural.Data.Folder

FolderIcon = React.createClass
  displayName: 'Folder Icon'
  render: ->
    {Icon, IconStack} = Structural.Components

    if isShared(@props.folder)
      IconStack {className: 'folder-icon-shared'},
        Icon({name: 'user', className: 'shared-icon-user'})
        Icon({name: 'plus', className: 'shared-icon-plus'})
    else
      Icon({name: 'folder-open', className: 'folder-icon'})

Structural.Components.FolderIcon = FolderIcon
