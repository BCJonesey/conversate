{div} = React.DOM

ConversationListSection = React.createClass
  displayName: 'Conversation List Section'
  render: ->
    {Conversation, EmptySectionMessage} = Structural.Components

    if @props.conversations.length == 0
      contents = EmptySectionMessage({adjective: @props.adjective})
    else
      makeConversation = (c) =>
        Conversation({
          conversation: c
          activeConversation: @props.activeConversation
          key: c.id})
      contents = _.map(@props.conversations, makeConversation)

    div {className: 'conversation-list-section'},
      div({className: 'conversation-list-section-title'}, @props.title),
      contents

Structural.Components.ConversationListSection = ConversationListSection
