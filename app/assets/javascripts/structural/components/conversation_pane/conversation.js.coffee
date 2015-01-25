{timestampToHumanizedTimestr} = Structural.Data.Time
{UpdateActiveConversation} = Structural.Actions
{Mouse} = Structural.Data
{div, a} = React.DOM

Conversation = React.createClass
  displayName: 'Conversation'
  render: ->
    {InlineParticipantList} = Structural.Components

    timestr = timestampToHumanizedTimestr(@props.conversation.most_recent_event)

    classes = ['conversation']
    if @props.conversation.id == @props.activeConversation
      classes.push('active-conversation')

    url = Structural.Urls.UrlFactory.conversation(@props.conversation)

    a {className: classes.join(' '), href: url, onClick: @viewConversation},
      div({className: 'conversation-title'}, @props.conversation.title),
      InlineParticipantList({
        participants: @props.conversation.participants,
        className: 'conversation-participants'})
      div({className: 'conversation-time'}, timestr)

  viewConversation: (event) ->
    if event.button == Mouse.LeftClick
      event.preventDefault()
      UpdateActiveConversation(@props.conversation.id)

Structural.Components.Conversation = React.createFactory(Conversation)
