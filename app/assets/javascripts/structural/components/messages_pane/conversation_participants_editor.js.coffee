{name} = Structural.Data.Participant
{UpdateUsers} = Structural.Actions
{div} = React.DOM

ConversationParticipantsEditor = React.createClass
  displayName: 'Conversation Participants Editor'

  getInitialState: ->
    return {
      participants: @props.conversation.participants
    }

  componentWillUnmount: ->
    oldParticipants = @props.conversation.participants
    newParticipants = @state.participants

    oldIds = _.pluck(oldParticipants, 'id')
    newIds = _.pluck(newParticipants, 'id')

    addedIds = _.difference(newIds, oldIds)
    removedIds = _.difference(oldIds, newIds)

    addedParticipants = _.filter newParticipants, (p) -> p.id in addedIds
    removedParticipants = _.filter oldParticipants, (p) -> p.id in removedIds
    UpdateUsers(addedParticipants, removedParticipants, @props.conversation, @props.folder, @props.currentUser)

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
