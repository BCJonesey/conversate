{Messages, Conversations, ActiveConversation, CurrentUser} = Structural.Stores
{div} = React.DOM

MessagesPane = React.createClass
  displayName: 'Action Pane'
  mixins: [
    Conversations.listen('updateConversation')
    ActiveConversation.listen('updateConversation')
    Messages.listen('onMessagesChange')
    CurrentUser.listen('updateUser')
  ]

  getInitialState: ->
    conversation: Conversations.byId(ActiveConversation.id())
    messages: Messages.distilled()
    currentUser: CurrentUser.getUser()

  updateConversation: ->
    @setState({conversation: Conversations.byId(ActiveConversation.id())})

  onMessagesChange: ->
    @setState messages: Messages.distilled()

  updateUser: ->
    @setState({currentUser: CurrentUser.getUser()})

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
      )
      Structural.Components.Compose(
        currentUser: @state.currentUser
        conversation: @state.conversation
      )


Structural.Components.MessagesPane = MessagesPane
