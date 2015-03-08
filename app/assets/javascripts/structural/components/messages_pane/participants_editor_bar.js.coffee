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
        content: ConversationParticipantsEditor({
          conversation: @props.conversation
          addressBook: @props.addressBook
          folder: @props.folder
          currentUser: @props.currentUser
        })
      }, IconButton({icon: 'plus'}))

Structural.Components.ParticipantsEditorBar =
  React.createFactory(ParticipantsEditorBar)
