{name} = Structural.Data.Participant
{div} = React.DOM

ConversationParticipantsEditor = React.createClass
  displayName: 'Conversation Participants Editor'

  getInitialState: ->
    return {
      participants: @props.conversation.participants
    }

  render: ->
    {RemovableParticipants, Autocomplete} = Structural.Components

    autocomplete = Autocomplete({
      inputClassName: 'participant-input'
      placeholder: 'Add people...'
      dictionary: @props.addressBook
      blacklist: @state.participants
      optionSelected: @participantSelected
    })

    participants = RemovableParticipants({
      participants: @state.participants
      removeParticipant: @participantRemoved
    })

    div {className: 'conversation-participants-editor'},
      autocomplete
      participants

  participantSelected: (participant) ->
    @state.participants.push(participant)
    @setState(participants: @state.participants)

  participantRemoved: (participant) ->
    participants = _.reject @state.participants, (p) ->
      p.id == participant.id
    @setState(participants: participants)

Structural.Components.ConversationParticipantsEditor =
  React.createFactory(ConversationParticipantsEditor)
