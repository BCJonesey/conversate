{ConversationsStore, ActiveConversationStore} = Structural.Stores
{div} = React.DOM

ActionPane = React.createClass
  displayName: 'Action Pane'
  getInitialState: ->
    {conversation: undefined}
  mixins: [
    ConversationsStore.listen('updateConversation')
    ActiveConversationStore.listen('updateConversation')
  ]
  render: ->
    div {className: 'ui-section act-container'},
      Structural.Components.ConversationEditorBar({
        conversation: @state.conversation
      })
      Structural.Components.ParticipantsEditorBar({
        conversation: @state.conversation
      })
      Structural.Components.ActionList()
      Structural.Components.Compose()

  updateConversation: ->
    if ActiveConversationStore.activeConversationId
      @setState({conversation: ConversationsStore.conversations[ActiveConversationStore.activeConversationId]})

Structural.Components.ActionPane = ActionPane
