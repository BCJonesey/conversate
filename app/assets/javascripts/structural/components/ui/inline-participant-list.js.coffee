{ul, li} = React.DOM

InlineParticipantClass = React.createClass
  displayName: 'Inline Participant List Item'
  render: ->
    name = Structural.Data.Participant.name(@props.participant)
    li {className: 'participant'}, name
InlineParticipant = React.createFactory(InlineParticipantClass)

InlineParticipantList = React.createClass
  displayName: 'Inline Participant List'
  render: ->
    participants = _.map(@props.participants,
                         (p) -> InlineParticipant({participant: p, key: p.id}))

    className = ['inline-participant-list', @props.className].join(' ')
    ul {className: className}, participants

Structural.Components.InlineParticipantList =
  React.createFactory(InlineParticipantList)
