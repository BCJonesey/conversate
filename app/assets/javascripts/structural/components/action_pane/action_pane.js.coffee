{ConversationsStore, ActiveConversationStore} = Structural.Stores
{ListenToStore} = Structural.Flux
{div} = React.DOM

ActionPane = React.createClass
  displayName: 'Action Pane'
  getInitialState: ->
    {conversation: undefined}
  mixins: [
    ListenToStore(ConversationsStore, 'updateConversation')
    ListenToStore(ActiveConversationStore, 'updateConversation')
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
