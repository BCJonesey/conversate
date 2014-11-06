{Conversations, CurrentUser} = Structural.Stores
{div} = React.DOM

ConversationPane = React.createClass
  displayName: 'Conversation Pane'
  mixins: [
    Conversations.listen('updateConversations')
    CurrentUser.listen('updateUser')
  ]

  getInitialState: ->
    conversations: Conversations.chronologicalOrder()
    user: CurrentUser.getUser()

  updateConversations: ->
    @setState(conversations: Conversations.chronologicalOrder())
  updateUser: ->
    @setState(user: CurrentUser.getUser())

  render: ->
    {ConversationList} = Structural.Components

    div {className: 'conversation-pane'},
      Structural.Components.ConversationActions(),
      ConversationList({conversations: @state.conversations, user: @state.user})

Structural.Components.ConversationPane = ConversationPane
