{div, ul, li} = React.DOM

Participant = React.createClass
  displayName: 'Participant List Item',
  render: ->
    name = Structural.Data.Participant.name(@props.participant)
    li {className: 'conversation-participant'}, name


ParticipantsEditorBar = React.createClass
  displayName: 'ParticipantsEditorBar'
  render: ->
    {InlineParticipantList} = Structural.Components

    if @props.conversation
      participants = @props.conversation.participants
    else
      participants = []

    div {className: 'conversation-participants-editor'},
      InlineParticipantList({
        participants: participants,
        className: 'conversation-participants-list'})

Structural.Components.ParticipantsEditorBar = ParticipantsEditorBar
