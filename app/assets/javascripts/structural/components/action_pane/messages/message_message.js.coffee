{timestampToHumanizedTimestr} = Structural.Data.Time
{div} = React.DOM

MessageMessage = React.createClass
  render: ->
    senderName = Structural.Data.Participant.name(@props.message.user)
    messageTimeStr = timestampToHumanizedTimestr(@props.message.timestamp)

    div {className: 'message message-message'},
      div {className: 'message-info'},
        div {className: 'message-details'}, messageTimeStr
        div {className: 'message-sender'}, senderName
      div {className: 'message-text'}, @props.message.text

Structural.Components.MessageMessage = MessageMessage
