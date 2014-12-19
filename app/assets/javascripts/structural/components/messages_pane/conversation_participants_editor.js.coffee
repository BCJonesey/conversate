{name} = Structural.Data.Participant
{div} = React.DOM

ConversationParticipantsEditor = React.createClass
  displayName: 'Conversation Participants Editor'
  render: ->
    {IconButton} = Structural.Components

    participants = _.map @props.conversation.participants, (p) ->
      div {className: 'participant', key: p.id}, name(p), IconButton({icon: 'times', className: 'remove-participant'})

    div {className: 'conversation-participants-editor'},
      div {className: 'participant-list'}, participants

Structural.Components.ConversationParticipantsEditor = ConversationParticipantsEditor
