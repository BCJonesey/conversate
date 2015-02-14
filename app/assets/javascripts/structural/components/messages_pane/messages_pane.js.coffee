{Messages, Conversations, ActiveConversation, CurrentUser, Folders,
 ActiveFolder, MessagesState, ContactLists} = Structural.Stores
{div} = React.DOM

MessagesPane = React.createClass
  displayName: 'Action Pane'
  mixins: [
    Folders.listenWith('updateConversation')
    ActiveFolder.listenWith('updateConversation')
    Conversations.listenWith('updateConversation')
    ActiveConversation.listenWith('updateConversation')
    Messages.listenWith('updateConversation')
    CurrentUser.listen('currentUser', CurrentUser.getUser)
    MessagesState.listenWith('updateMessagesState')
    ContactLists.listen('addressBook', ContactLists.allUsers)
  ]

  updateConversation: ->
    folder = Folders.byId(ActiveFolder.id())
    conversation = Conversations.byId(folder, ActiveConversation.id())
    return {
      folder: folder
      conversation: conversation
      messages: Messages.distilled(conversation)
    }
  updateMessagesState: ->
    return {
      loading: MessagesState.isLoading()
      none: MessagesState.isNone()
    }

  render: ->
    div {className: 'message-pane'},
      Structural.Components.ConversationEditorBar(
        conversation: @state.conversation
        folders: Folders.asList()
        currentFolder: @state.folder
        currentUser: @state.currentUser
      )
      Structural.Components.ParticipantsEditorBar(
        conversation: @state.conversation
        addressBook: @state.addressBook
      )
      Structural.Components.MessagesList(
        messages: @state.messages
        loading: @state.loading
        none: @state.none
        currentUser: @state.currentUser
        conversation: @state.conversation
        folder: @state.folder
      )
      Structural.Components.Compose(
        currentUser: @state.currentUser
        conversation: @state.conversation
      )


Structural.Components.MessagesPane = React.createFactory(MessagesPane)
