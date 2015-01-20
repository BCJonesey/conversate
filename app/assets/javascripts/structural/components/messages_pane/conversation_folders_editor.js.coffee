{Folders} = Structural.Stores
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
    {Button} = Structural.Components

    addedIds = _.difference(@state.folderIds, @props.conversation.folder_ids)
    removedIds = _.difference(@props.conversation.folder_ids, @state.folderIds)
    added = _.map(addedIds, (id) -> Folders.byId(id))
    removed = _.map(removedIds, (id) -> Folders.byId(id))

    checkBoxes = _.map @props.folders, (folder) =>
      FolderCheckbox({
        folder: folder,
        folderIds: @state.folderIds
        check: @checkFolder
        uncheck: @uncheckFolder
        key: folder.id
      })

    div {className: 'conversation-folders-editor'},
      div({className: 'folders'}, checkBoxes)
      div({className: 'save-changes'}, Button({
        action: Structural.Actions.UpdateFolders
        actionArgs: [
          added
          removed
          @props.conversation
          @props.currentFolder
          @props.currentUser
        ]
        onClick: Structural.Actions.CloseMenu
      }, 'Update Folders'))

  checkFolder: (folder) ->
    @setState(folderIds: _.union(@state.folderIds, [folder.id]))
  uncheckFolder: (folder) ->
    if @state.folderIds.length > 1
      @setState(folderIds: _.without(@state.folderIds, folder.id))

Structural.Components.ConversationFoldersEditor =
  React.createFactory(ConversationFoldersEditor)
