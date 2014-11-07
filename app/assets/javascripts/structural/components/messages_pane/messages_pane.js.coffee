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
    conversation = Conversations.byId(ActiveConversation.id())

    return {
      conversation: conversation
      messages: Messages.distilled(conversation)
      currentUser: CurrentUser.getUser()
    }

  updateConversation: ->
    conversation = Conversations.byId(ActiveConversation.id())
    @setState(
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
      )
      Structural.Components.Compose(
        currentUser: @state.currentUser
        conversation: @state.conversation
      )


Structural.Components.MessagesPane = MessagesPane
