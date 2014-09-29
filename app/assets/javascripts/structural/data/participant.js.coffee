Participant = {
  name: (participant) ->
    if participant.full_name then participant.full_name else participant.email
}

Structural.Data.Participant = Participant
