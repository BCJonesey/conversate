{div, span} = React.DOM

ConversationEditorBar = React.createClass
  displayName: 'Conversation Editor Bar'
  render: ->
    title = if @props.conversation then @props.conversation.title else ''
    div {className: 'conversation-editor'},
      span {className: 'conversation-title'}, title

Structural.Components.ConversationEditorBar = ConversationEditorBar
