{div} = React.DOM

ConversationEditorBar = React.createClass
  displayName: 'Conversation Editor Bar'
  render: ->
    div {className: 'btn-toolbar act-title'}

Structural.Components.ConversationEditorBar = ConversationEditorBar
