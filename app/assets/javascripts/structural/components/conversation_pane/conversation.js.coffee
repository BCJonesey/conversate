{timestampToHumanizedTimestr} = Structural.Data.Time
{div} = React.DOM

Conversation = React.createClass
  displayName: 'Conversation'
  render: ->
    timestr = timestampToHumanizedTimestr(@props.conversation.most_recent_event)

    div {className: 'conversation'},
      div({className: 'conversation-title'}, @props.conversation.title),
      div({className: 'conversation-participants'}, 'James'),
      div({className: 'conversation-time'}, timestr)

Structural.Components.Conversation = Conversation
