{div} = React.DOM

ConversationListSection = React.createClass
  displayName: 'Conversation List Section'
  getInitialState: ->
    open: not @props.startCollapsed
  render: ->
    {Conversation,
     EmptySectionMessage,
     CollapsedSectionMessage} = Structural.Components

    if @props.conversations.length == 0
      contents = EmptySectionMessage({
        adjective: @props.adjective
        description: @props.description
      })
    else if not @state.open
      onClick = @open
      contents = CollapsedSectionMessage({
        conversations: @props.conversations
        adjective: @props.adjective
        onClick: onClick})
    else
      onClick = @close
      makeConversation = (c) =>
        Conversation({
          conversation: c
          activeConversation: @props.activeConversation
          key: c.id})
      contents = _.map(@props.conversations, makeConversation)

    div {className: 'conversation-list-section'},
      div({className: 'conversation-list-section-title', onClick: onClick}, @props.title),
      contents

  open: -> @setState(open: true)
  close: -> @setState(open: false)

Structural.Components.ConversationListSection = ConversationListSection
