{div} = React.DOM

FolderList = React.createClass
  displayName: 'Folder List'
  render: ->
    {Folder} = Structural.Components

    folders = _.map(@props.folders, (f) -> Folder({folder: f, key: f.id}))

    div {className: 'folder-list'}, folders

Structural.Components.FolderList = FolderList
