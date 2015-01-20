{div} = React.DOM

ConversationActions = React.createClass
  displayName: 'Conversation Actions'
  render: ->
    div {className: 'conversation-actions'}

Structural.Components.ConversationActions =
  React.createFactory(ConversationActions)
