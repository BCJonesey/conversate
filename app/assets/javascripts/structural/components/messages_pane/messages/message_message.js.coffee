{timestampToHumanizedTimestr, fiveMinutesInMilliseconds} = Structural.Data.Time
{div} = React.DOM

MessageMessage = React.createClass
  render: ->
    senderName = Structural.Data.Participant.name(@props.message.user)
    messageTimeStr = timestampToHumanizedTimestr(@props.message.timestamp, new Date(), {alwaysIncludeHourMinute: true})

    followOns = null
    if @props.message.followOns
      followOns = []
      lastTimestamp = @props.message.timestamp
      _.forEach @props.message.followOns, (followOn) ->
        if (followOn.timestamp - lastTimestamp) > fiveMinutesInMilliseconds
          msgTime = timestampToHumanizedTimestr(followOn.timestamp, new Date(), {onlyIncludeHourMinute: true})
          followOns.push div {className: 'message-info'},
            div {className: 'message-details'}, msgTime
          lastTimestamp = followOn.timestamp
        followOns.push div {className: 'message-text'}, followOn.text

    div {className: 'message-message'},
      div {className: 'message-info'},
        div {className: 'message-details'}, messageTimeStr
        div {className: 'message-sender'}, senderName
      div {className: 'message-text'}, @props.message.text
      followOns

Structural.Components.MessageMessage = MessageMessage
