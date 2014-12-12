{div, span} = React.DOM

ConversationEditorBar = React.createClass
  displayName: 'Conversation Editor Bar'
  render: ->
    {MenuTrigger, IconButton, ConversationDetailsEditor} = Structural.Components

    title = if @props.conversation then @props.conversation.title else ''
    div {className: 'conversation-editor'},
      span({className: 'conversation-title'}, title),
      MenuTrigger({
        className: 'details-editor-trigger'
        title: 'Conversation Details'
        content: ConversationDetailsEditor({
          conversation: @props.conversation
          folder: @props.folder
          currentUser: @props.currentUser
        })
      }, IconButton({icon: 'chevron-down'}))
      MenuTrigger({
        className: 'conversation-folders-trigger'
        title: 'Folders'
        content: 'Folders TBD'
      }, IconButton({icon: 'folder-open-o'}))

Structural.Components.ConversationEditorBar = ConversationEditorBar
