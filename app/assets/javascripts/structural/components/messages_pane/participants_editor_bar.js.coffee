{div, ul, li} = React.DOM

Participant = React.createClass
  displayName: 'Participant List Item',
  render: ->
    name = Structural.Data.Participant.name(@props.participant)
    li {className: 'act-participant'}, name


ParticipantsEditorBar = React.createClass
  displayName: 'ParticipantsEditorBar'
  render: ->
    if @props.conversation
      participants = _.map(@props.conversation.participants,
                           (p) -> Participant({participant: p, key: p.id}))
    else
      participants = []

    div {className: 'act-participants'},
      ul {className: 'act-participants-list'},
        participants

Structural.Components.ParticipantsEditorBar = ParticipantsEditorBar
