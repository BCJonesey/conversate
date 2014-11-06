{timestampToHumanizedTimestr} = Structural.Data.Time
{div} = React.DOM

Conversation = React.createClass
  displayName: 'Conversation'
  render: ->
    {InlineParticipantList} = Structural.Components

    timestr = timestampToHumanizedTimestr(@props.conversation.most_recent_event)

    div {className: 'conversation'},
      div({className: 'conversation-title'}, @props.conversation.title),
      InlineParticipantList({
        participants: @props.conversation.participants,
        className: 'conversation-participants'})
      div({className: 'conversation-time'}, timestr)

Structural.Components.Conversation = Conversation
