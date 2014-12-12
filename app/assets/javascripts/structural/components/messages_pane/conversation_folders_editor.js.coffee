{div, span} = React.DOM

FolderCheckbox = React.createClass
  displayName: 'Folder Checkbox'
  render: ->
    {Icon} = Structural.Components

    checked = @props.folder.id in @props.folderIds
    if checked
      icon = 'check-square-o'
      className = 'folder-checkbox-checked'
      action = @props.uncheck
    else
      icon = 'square-o'
      className = 'folder-checkbox'
      action = @props.check

    div {className: className, onClick: () => action(@props.folder)},
      Icon({name: icon})
      span({className: 'folder-name'}, @props.folder.name)

ConversationFoldersEditor = React.createClass
  displayName: 'Conversation Folders Editor'
  getInitialState: ->
    folderIds: @props.conversation.folder_ids
  render: ->
    checkBoxes = _.map @props.folders, (folder) =>
      FolderCheckbox({
        folder: folder,
        folderIds: @state.folderIds
        check: @checkFolder
        uncheck: @uncheckFolder
        key: folder.id
      })

    div {className: 'conversation-folders-editor'},
      checkBoxes

  checkFolder: (folder) ->
    @setState(folderIds: _.union(@state.folderIds, [folder.id]))
  uncheckFolder: (folder) ->
    if @state.folderIds.length > 1
      @setState(folderIds: _.without(@state.folderIds, folder.id))

Structural.Components.ConversationFoldersEditor = ConversationFoldersEditor
