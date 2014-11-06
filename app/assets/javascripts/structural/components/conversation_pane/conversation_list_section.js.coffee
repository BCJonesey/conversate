{div} = React.DOM

ConversationListSection = React.createClass
  displayName: 'Conversation List Section'
  render: ->
    {Conversation} = Structural.Components

    makeConversation = (c) =>
      Conversation({
        conversation: c
        activeConversation: @props.activeConversation
        key: c.id})
    convos = _.map(@props.conversations, makeConversation)

    div {className: 'conversation-list-section'},
      div({className: 'conversation-list-section-title'}, @props.title),
      convos

Structural.Components.ConversationListSection = ConversationListSection
