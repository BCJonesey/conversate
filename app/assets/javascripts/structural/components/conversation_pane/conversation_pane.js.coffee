{div} = React.DOM

ConversationPane = React.createClass
  displayName: 'Conversation Pane'
  render: ->
    div {className: 'conversation-pane'}

Structural.Components.ConversationPane = ConversationPane
