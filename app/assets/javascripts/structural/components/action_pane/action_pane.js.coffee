{MessagesStore, ConversationsStore, ActiveConversationStore} = Structural.Stores
{div} = React.DOM

ActionPane = React.createClass
  displayName: 'Action Pane'

  getInitialState: ->
    conversation: undefined
    messages: MessagesStore.messages

  componentDidMount: ->
    ConversationsStore.listen(@updateConversation)
    ActiveConversationStore.listen(@updateConversation)
    MessagesStore.listen(@onMessagesChange)

  componentWillUnmount: ->
    ConversationsStore.ignore(@updateConversation)
    ActiveConversationStore.ignore(@updateConversation)
    MessagesStore.ignore(@updateConversation)

  updateConversation: ->
    if ActiveConversationStore.activeConversationId
      @setState({conversation: ConversationsStore.conversations[ActiveConversationStore.activeConversationId]})

  onMessagesChange: ->
    @setState messages: MessagesStore.messages

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
