{div} = React.DOM

ConversationPane = React.createClass
  displayName: 'Conversation Pane'
  render: ->
    div {className: 'ui-section cnv-container'}

Structural.Components.ConversationPane = ConversationPane
