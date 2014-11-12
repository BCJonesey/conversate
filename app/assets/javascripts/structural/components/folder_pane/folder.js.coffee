{div, a} = React.DOM

Folder = React.createClass
  displayName: 'Folder'
  render: ->
    {FolderIcon} = Structural.Components

    classes = ['folder']
    if @props.folder.id == @props.activeFolder
      classes.push('active-folder')

    url = Structural.UrlFactory.folder(@props.folder)

    a {className: classes.join(' '), href: url, onClick: @viewFolder},
      FolderIcon({folder: @props.folder})
      div({className: 'folder-name'}, @props.folder.name)

  viewFolder: (event) ->
    if event.button == 0 # Left Click
      event.preventDefault()
      # TODO: Folder View Action

Structural.Components.Folder = Folder
