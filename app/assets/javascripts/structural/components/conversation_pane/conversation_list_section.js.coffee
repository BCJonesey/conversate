{div} = React.DOM

ConversationListSection = React.createClass
  displayName: 'Conversation List Section'
  render: ->
    {Conversation} = Structural.Components

    convos = _.map(@props.conversations,
                  (c) -> Conversation({conversation: c, key: c.id}))

    div {className: 'conversation-list-section'},
      div({className: 'conversation-list-section-title'}, @props.title),
      convos

Structural.Components.ConversationListSection = ConversationListSection
