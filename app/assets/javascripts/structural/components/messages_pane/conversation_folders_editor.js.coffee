{div, span} = React.DOM

FolderCheckbox = React.createClass
  displayName: 'Folder Checkbox'
  render: ->
    {Icon} = Structural.Components

    checked = @props.folder.id in @props.conversation.folder_ids
    if checked
      icon = 'check-square-o'
    else
      icon = 'square-o'

    className = "folder-checkbox#{if checked then '-checked' else ''}"

    div {className: className},
      Icon({name: icon})
      span({className: 'folder-name'}, @props.folder.name)

ConversationFoldersEditor = React.createClass
  displayName: 'Conversation Folders Editor'
  render: ->
    checkBoxes = _.map @props.folders, (folder) =>
      FolderCheckbox({
        folder: folder,
        conversation: @props.conversation
        key: folder.id
      })

    div {className: 'conversation-folders-editor'},
      checkBoxes

Structural.Components.ConversationFoldersEditor = ConversationFoldersEditor
