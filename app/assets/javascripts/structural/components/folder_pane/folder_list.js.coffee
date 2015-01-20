{div} = React.DOM

FolderList = React.createClass
  displayName: 'Folder List'

  componentDidUpdate: ->
    dom = @getDOMNode()
    # There should only ever be one active folder.  If there's more than one,
    # something's gone very wrong.
    active = _.first(dom.getElementsByClassName('active-folder'))

    if not active
      return

    activeTop = active.offsetTop
    activeBottom = activeTop + active.clientHeight
    scrollTop = dom.scrollTop
    scrollBottom = scrollTop + dom.clientHeight

    if activeBottom >= scrollTop and activeTop <= scrollBottom
      return

    dom.scrollTop = activeTop - (dom.clientHeight / 2)

  render: ->
    {Folder} = Structural.Components

    folders = _.map(@props.folders, (f) => Folder({
      folder: f,
      activeFolder: @props.activeFolder
      key: f.id}))

    div {className: 'folder-list'}, folders

Structural.Components.FolderList = React.createFactory(FolderList)
