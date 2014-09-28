{div, span} = React.DOM

ConversationEditorBar = React.createClass
  displayName: 'Conversation Editor Bar'
  render: ->
    title = if @props.conversation then @props.conversation.title else ''
    div {className: 'btn-toolbar act-title'},
      span {className: 'act-title-input'}, title

Structural.Components.ConversationEditorBar = ConversationEditorBar
