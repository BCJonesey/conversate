{div} = React.DOM

ConversationListSection = React.createClass
  displayName: 'Conversation List Section'
  render: ->
    div {className: 'conversation-list-section'},
      div({className: 'conversation-list-section-title'}, @props.title)

Structural.Components.ConversationListSection = ConversationListSection
