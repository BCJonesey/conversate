Participant = {
  name: (participant) ->
    if not participant
      ''
    else if participant.name
      participant.name
    else if participant.full_name
      participant.full_name
    else
      participant.email
}

Structural.Data.Participant = Participant
