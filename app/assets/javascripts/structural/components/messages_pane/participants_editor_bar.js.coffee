{div, ul, li} = React.DOM

Participant = React.createClass
  displayName: 'Participant List Item',
  render: ->
    name = Structural.Data.Participant.name(@props.participant)
    li {className: 'conversation-participant'}, name


ParticipantsEditorBar = React.createClass
  displayName: 'ParticipantsEditorBar'
  render: ->
    {InlineParticipantList, MenuTrigger, IconButton, ConversationParticipantsEditor} = Structural.Components

    if @props.conversation
      participants = @props.conversation.participants
    else
      participants = []

    div {className: 'conversation-participants-editor'},
      InlineParticipantList({
        participants: participants,
        className: 'conversation-participants-list'})
      MenuTrigger({
        className: 'participant-editor-trigger'
        title: 'Participants'
        content: ConversationParticipantsEditor({conversation: @props.conversation})
      }, IconButton({icon: 'plus'}))

Structural.Components.ParticipantsEditorBar = ParticipantsEditorBar
