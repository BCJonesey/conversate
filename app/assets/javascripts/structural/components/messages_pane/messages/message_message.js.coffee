{fiveMinutesInMilliseconds} = Structural.Data.Time
{isUsersMessage} = Structural.Data.Message
{div} = React.DOM

MessageMessage = React.createClass
  render: ->
    if @props.message.followOns
      followOns = []
      lastTimestamp = @props.message.timestamp
      _.forEach @props.message.followOns, (followOn) ->
        if (followOn.timestamp - lastTimestamp) > fiveMinutesInMilliseconds
          followOns.push Structural.Components.MessageInfo {
              includeTime: true
              onlyIncludeHourMinute: true
              message: followOn
            }
          lastTimestamp = followOn.timestamp

        followOns.push div {className: 'message-text'}, followOn.text

    klass = 'message-message'
    if isUsersMessage(@props.message, @props.currentUser)
      klass = "#{klass} current-users-message"

    div {className: klass},
      Structural.Components.MessageInfo {
        includeSender: true,
        includeTime: true,
        alwaysIncludeHourMinute: true
        message: @props.message
      }
      div {className: 'message-text'}, @props.message.text
      followOns

Structural.Components.MessageMessage = MessageMessage
