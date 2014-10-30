{div} = React.DOM

ConversationPane = React.createClass
  displayName: 'Conversation Pane'
  render: ->
    div {className: 'conversation-pane'},
      Structural.Components.ConversationActions()

Structural.Components.ConversationPane = ConversationPane
