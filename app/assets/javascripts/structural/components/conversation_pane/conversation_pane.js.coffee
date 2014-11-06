{Conversations, CurrentUser, ActiveConversation} = Structural.Stores
{div} = React.DOM

ConversationPane = React.createClass
  displayName: 'Conversation Pane'
  mixins: [
    Conversations.listen('updateConversations')
    CurrentUser.listen('updateUser')
    ActiveConversation.listen('updateActiveConversation')
  ]

  getInitialState: ->
    conversations: Conversations.chronologicalOrder()
    user: CurrentUser.getUser()
    activeConversation: ActiveConversation.id()

  updateConversations: ->
    @setState(conversations: Conversations.chronologicalOrder())
  updateUser: ->
    @setState(user: CurrentUser.getUser())
  updateActiveConversation: ->
    @setState(activeConversation: ActiveConversation.id())

  render: ->
    {ConversationList} = Structural.Components

    div {className: 'conversation-pane'},
      Structural.Components.ConversationActions(),
      ConversationList({
        conversations: @state.conversations
        user: @state.user
        activeConversation: @state.activeConversation})

Structural.Components.ConversationPane = ConversationPane
