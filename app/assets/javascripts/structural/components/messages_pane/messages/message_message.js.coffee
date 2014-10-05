{timestampToHumanizedTimestr, fiveMinutesInMilliseconds} = Structural.Data.Time
{isUsersMessage} = Structural.Data.Message
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

    klass = 'message-message'
    if isUsersMessage(@props.message, @props.currentUser)
      klass = "#{klass} current-users-message"

    div {className: klass},
      div {className: 'message-info'},
        div {className: 'message-details'}, messageTimeStr
        div {className: 'message-sender'}, senderName
      div {className: 'message-text'}, @props.message.text
      followOns

Structural.Components.MessageMessage = MessageMessage
