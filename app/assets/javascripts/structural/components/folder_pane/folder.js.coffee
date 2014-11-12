{div, a} = React.DOM

Folder = React.createClass
  displayName: 'Folder'
  render: ->
    {Icon} = Structural.Components

    a {className: 'folder', href: '#', onClick: @viewFolder},
      Icon({name: 'folder-o', className: 'folder-icon'})
      div({className: 'folder-name'}, @props.folder.name)

  viewFolder: (event) ->
    if event.button == 0 # Left Click
      event.preventDefault()
      # TODO: Folder View Action

Structural.Components.Folder = Folder
