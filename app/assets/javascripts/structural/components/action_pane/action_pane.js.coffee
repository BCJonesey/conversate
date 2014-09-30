{MessagesStore, ConversationsStore, ActiveConversationStore} = Structural.Stores
{div} = React.DOM

ActionPane = React.createClass
  displayName: 'Action Pane'
  mixins: [
    ConversationsStore.listen('updateConversation')
    ActiveConversationStore.listen('updateConversation')
    MessagesStore.listen('onMessagesChange')
  ]

  getInitialState: ->
    conversation: undefined
    messages: MessagesStore.sortedMessages()

  updateConversation: ->
    if ActiveConversationStore.activeConversationId
      @setState({conversation: ConversationsStore.conversations[ActiveConversationStore.activeConversationId]})

  onMessagesChange: ->
    @setState messages: MessagesStore.sortedMessages()

  render: ->
    div {className: 'ui-section act-container'},
      Structural.Components.ConversationEditorBar({
        conversation: @state.conversation
      })
      Structural.Components.ParticipantsEditorBar({
        conversation: @state.conversation
      })
      Structural.Components.ActionList(messages:@state.messages)
      Structural.Components.Compose()


Structural.Components.ActionPane = ActionPane
