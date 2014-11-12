{fiveMinutesInMilliseconds} = Structural.Data.Time
{isUsersMessage} = Structural.Data.Message
{div} = React.DOM

MessageMessage = React.createClass
  displayName: 'Message Message Message'
  render: ->
    if @props.message.followOns
      followOns = []
      lastTimestamp = @props.message.timestamp
      _.forEach @props.message.followOns, (followOn) =>
        if (followOn.timestamp - lastTimestamp) > fiveMinutesInMilliseconds
          followOns.push Structural.Components.MessageInfo {
              includeTime: true
              onlyIncludeHourMinute: true
              message: followOn
            }
          lastTimestamp = followOn.timestamp

        followOns.push Structural.Components.MessageText {
          message: followOn
          conversation: @props.conversation
        }

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
      Structural.Components.MessageText {
        message: @props.message
        conversation: @props.conversation
        folder: @props.folder
      }
      followOns

Structural.Components.MessageMessage = MessageMessage
