{Messages, Conversations, ActiveConversation, CurrentUser, Folders,
 ActiveFolder} = Structural.Stores
{div} = React.DOM

MessagesPane = React.createClass
  displayName: 'Action Pane'
  mixins: [
    Folders.listen('updateConversation')
    ActiveFolder.listen('updateConversation')
    Conversations.listen('updateConversation')
    ActiveConversation.listen('updateConversation')
    Messages.listen('onMessagesChange')
    CurrentUser.listen('updateUser')
  ]

  getInitialState: ->
    folder = Folders.byId(ActiveFolder.id())
    conversation = Conversations.byId(folder, ActiveConversation.id())

    return {
      folder: folder
      conversation: conversation
      messages: Messages.distilled(conversation)
      currentUser: CurrentUser.getUser()
    }

  updateConversation: ->
    folder = Folders.byId(ActiveFolder.id())
    conversation = Conversations.byId(folder, ActiveConversation.id())
    @setState(
      folder: folder
      conversation: conversation
      messages: Messages.distilled(conversation)
    )

  onMessagesChange: ->
    @setState(messages: Messages.distilled(@state.conversation))

  updateUser: ->
    @setState(currentUser: CurrentUser.getUser())

  render: ->
    div {className: 'message-pane'},
      Structural.Components.ConversationEditorBar(
        conversation: @state.conversation
      )
      Structural.Components.ParticipantsEditorBar(
        conversation: @state.conversation
      )
      Structural.Components.MessagesList(
        messages: @state.messages
        currentUser: @state.currentUser
        conversation: @state.conversation
        folder: @state.folder
      )
      Structural.Components.Compose(
        currentUser: @state.currentUser
        conversation: @state.conversation
      )


Structural.Components.MessagesPane = MessagesPane
