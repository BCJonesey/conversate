{timestampToHumanizedTimestr} = Structural.Data.Time
{div, a} = React.DOM

Conversation = React.createClass
  displayName: 'Conversation'
  render: ->
    {InlineParticipantList} = Structural.Components

    timestr = timestampToHumanizedTimestr(@props.conversation.most_recent_event)

    classes = ['conversation']
    if @props.conversation.id == @props.activeConversation
      classes.push('active-conversation')

    a {className: classes.join(' '), href: '#', onClick: @viewConversation},
      div({className: 'conversation-title'}, @props.conversation.title),
      InlineParticipantList({
        participants: @props.conversation.participants,
        className: 'conversation-participants'})
      div({className: 'conversation-time'}, timestr)

  viewConversation: (event) ->
    event.preventDefault()

Structural.Components.Conversation = Conversation
