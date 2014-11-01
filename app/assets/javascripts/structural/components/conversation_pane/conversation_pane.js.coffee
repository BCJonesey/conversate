{Conversations} = Structural.Stores
{isPinned} = Structural.Data.Conversation
{div} = React.DOM

ConversationPane = React.createClass
  displayName: 'Conversation Pane'
  mixins: [
    Conversations.listen('updateConversations')
  ]

  getInitialState: ->
    conversations: Conversations.chronologicalOrder()

  updateConversations: ->
    @setState(conversations: Conversations.chronologicalOrder())

  render: ->
    Section = Structural.Components.ConversationListSection

    pinnedConvos = _.filter(@state.conversations, isPinned)

    div {className: 'conversation-pane'},
      Structural.Components.ConversationActions(),
      Section({title: 'Pinned Conversations', conversations: pinnedConvos})

Structural.Components.ConversationPane = ConversationPane
