{Conversations, CurrentUser, ActiveConversation, Folders,
 ActiveFolder} = Structural.Stores
{div} = React.DOM

ConversationPane = React.createClass
  displayName: 'Conversation Pane'
  mixins: [
    Conversations.listen('updateConversations')
    CurrentUser.listen('updateUser')
    ActiveConversation.listen('updateActiveConversation')
    Folders.listen('updateConversations')
    ActiveFolder.listen('updateConversations')
  ]

  getInitialState: ->
    folder = Folders.byId(ActiveFolder.id())

    conversations: Conversations.chronologicalOrder(folder)
    user: CurrentUser.getUser()
    activeConversation: ActiveConversation.id()

  updateConversations: ->
    folder = Folders.byId(ActiveFolder.id())
    @setState(conversations: Conversations.chronologicalOrder(folder))
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
