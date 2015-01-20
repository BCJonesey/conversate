{UpdateActiveFolder} = Structural.Actions
{div, a} = React.DOM

Folder = React.createClass
  displayName: 'Folder'
  render: ->
    {FolderIcon} = Structural.Components

    classes = ['folder']
    if @props.folder.id == @props.activeFolder
      classes.push('active-folder')

    url = Structural.Urls.UrlFactory.folder(@props.folder)

    a {className: classes.join(' '), href: url, onClick: @viewFolder},
      FolderIcon({folder: @props.folder})
      div({className: 'folder-name'}, @props.folder.name)

  viewFolder: (event) ->
    if event.button == 0 # Left Click
      event.preventDefault()
      UpdateActiveFolder(@props.folder.id)

Structural.Components.Folder = React.createFactory(Folder)
