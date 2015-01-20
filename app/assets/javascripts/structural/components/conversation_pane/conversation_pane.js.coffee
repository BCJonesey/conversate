{Conversations, CurrentUser, ActiveConversation, Folders,
 ActiveFolder, ConversationsState} = Structural.Stores
{div} = React.DOM

ConversationPane = React.createClass
  displayName: 'Conversation Pane'
  mixins: [
    Conversations.listenWith('updateConversations')
    ActiveFolder.listenWith('updateConversations')
    Folders.listenWith('updateConversations')
    CurrentUser.listen('user', CurrentUser.getUser)
    ActiveConversation.listen('activeConversation', ActiveConversation.id)
    ConversationsState.listen('loading', ConversationsState.isLoading)
  ]

  updateConversations: ->
    folder = Folders.byId(ActiveFolder.id())
    return {
      conversations: Conversations.chronologicalOrder(folder)
    }

  render: ->
    {ConversationList} = Structural.Components

    div {className: 'conversation-pane'},
      Structural.Components.ConversationActions(),
      ConversationList({
        conversations: @state.conversations
        loading: @state.loading
        user: @state.user
        activeConversation: @state.activeConversation})

Structural.Components.ConversationPane = React.createFactory(ConversationPane)
