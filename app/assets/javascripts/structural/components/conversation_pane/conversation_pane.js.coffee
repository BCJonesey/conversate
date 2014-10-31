{div} = React.DOM

ConversationPane = React.createClass
  displayName: 'Conversation Pane'
  render: ->
    Section = Structural.Components.ConversationListSection

    div {className: 'conversation-pane'},
      Structural.Components.ConversationActions(),
      Section({title: 'Pinned Conversations'})

Structural.Components.ConversationPane = ConversationPane
