{name} = Structural.Data.Participant
{div} = React.DOM

ConversationParticipantsEditor = React.createClass
  displayName: 'Conversation Participants Editor'

  getInitialState: ->
    return {
      participants: @props.conversation.participants
    }

  render: ->
    {IconButton, Autocomplete} = Structural.Components

    participants = _.map @state.participants, (p) ->
      div {className: 'participant', key: p.id}, name(p), IconButton({icon: 'times', className: 'remove-participant'})

    div {className: 'conversation-participants-editor'},
      Autocomplete({
        inputClassName: 'participant-input'
        placeholder: 'Add people...'
        dictionary: @props.addressBook
        blacklist: @state.participants
        optionSelected: @participantSelected
      })
      div {className: 'participant-list'}, participants

  participantSelected: (participant) ->
    @state.participants.push(participant)
    @setState(participants: @state.participants)

Structural.Components.ConversationParticipantsEditor =
  React.createFactory(ConversationParticipantsEditor)
