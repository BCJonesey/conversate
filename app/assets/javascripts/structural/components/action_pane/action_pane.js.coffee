{Messages, Conversations, ActiveConversation} = Structural.Stores
{div} = React.DOM

ActionPane = React.createClass
  displayName: 'Action Pane'
  mixins: [
    Conversations.listen('updateConversation')
    ActiveConversation.listen('updateConversation')
    Messages.listen('onMessagesChange')
  ]

  getInitialState: ->
    conversation: Conversations.byId(ActiveConversation.id())
    messages: Messages.chronologicalOrder()

  updateConversation: ->
    @setState({conversation: Conversations.byId(ActiveConversation.id())})

  onMessagesChange: ->
    @setState messages: Messages.chronologicalOrder()

  render: ->
    div {className: 'ui-section act-container'},
      Structural.Components.ConversationEditorBar(
        conversation: @state.conversation
      )
      Structural.Components.ParticipantsEditorBar(
        conversation: @state.conversation
      )
      Structural.Components.ActionList(messages: @state.messages)
      Structural.Components.Compose()


Structural.Components.ActionPane = ActionPane
