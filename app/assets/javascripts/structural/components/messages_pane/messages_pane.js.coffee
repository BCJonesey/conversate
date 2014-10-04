{Messages, Conversations, ActiveConversation} = Structural.Stores
{div} = React.DOM

MessagesPane = React.createClass
  displayName: 'Action Pane'
  mixins: [
    Conversations.listen('updateConversation')
    ActiveConversation.listen('updateConversation')
    Messages.listen('onMessagesChange')
  ]

  getInitialState: ->
    conversation: Conversations.byId(ActiveConversation.id())
    messages: Messages.distilled()

  updateConversation: ->
    @setState({conversation: Conversations.byId(ActiveConversation.id())})

  onMessagesChange: ->
    @setState messages: Messages.distilled()

  render: ->
    div {className: 'message-pane'},
      Structural.Components.ConversationEditorBar(
        conversation: @state.conversation
      )
      Structural.Components.ParticipantsEditorBar(
        conversation: @state.conversation
      )
      Structural.Components.MessagesList(messages: @state.messages)
      Structural.Components.Compose()


Structural.Components.MessagesPane = MessagesPane
