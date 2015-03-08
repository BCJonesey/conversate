{name} = Structural.Data.Participant
{div} = React.DOM

RemovableParticipants = React.createClass
  displayName: 'Removable Participants'
  render: ->
    {IconButton} = Structural.Components

    participants = _.map @props.participants, (p) =>
      div {className: 'participant', key: p.id},
        name(p),
        IconButton({
          icon: 'times'
          className: 'remove-participant'
          onClick: _.partial(@remove, p)
        })

    div {className: 'participant-list'},
      participants

  remove: (participant) ->
    @props.removeParticipant(participant)

Structural.Components.RemovableParticipants = RemovableParticipants
