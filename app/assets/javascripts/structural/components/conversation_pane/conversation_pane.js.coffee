{Conversations, CurrentUser, ActiveConversation, Folders,
 ActiveFolder, ConversationsState} = Structural.Stores
{div} = React.DOM

ConversationPane = React.createClass
  displayName: 'Conversation Pane'
  mixins: [
    Conversations.listen('updateConversations')
    CurrentUser.listen('updateUser')
    ActiveConversation.listen('updateActiveConversation')
    Folders.listen('updateConversations')
    ActiveFolder.listen('updateConversations')
    ConversationsState.listen('updateConversationsState')
  ]

  getInitialState: ->
    folder = Folders.byId(ActiveFolder.id())

    conversations: Conversations.chronologicalOrder(folder)
    user: CurrentUser.getUser()
    activeConversation: ActiveConversation.id()
    loading: ConversationsState.isLoading()

  updateConversations: ->
    folder = Folders.byId(ActiveFolder.id())
    @setState(conversations: Conversations.chronologicalOrder(folder))
  updateUser: ->
    @setState(user: CurrentUser.getUser())
  updateActiveConversation: ->
    @setState(activeConversation: ActiveConversation.id())
  updateConversationsState: ->
    @setState(loading: ConversationsState.isLoading())

  render: ->
    {ConversationList} = Structural.Components

    div {className: 'conversation-pane'},
      Structural.Components.ConversationActions(),
      ConversationList({
        conversations: @state.conversations
        loading: @state.loading
        user: @state.user
        activeConversation: @state.activeConversation})

Structural.Components.ConversationPane = ConversationPane
