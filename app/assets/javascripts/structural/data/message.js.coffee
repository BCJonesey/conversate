fiveMinutesInMilliseconds = 5 * 60 * 1000

Message = {
  isMessageType: (message) ->
    message.type in ['message', 'email_message', 'upload_message']

  isFollowOn: (message, prevMessage) ->
    Message.isMessageType(message) and
    Message.isMessageType(prevMessage) and
    message.user.id == prevMessage.user.id and
    (Message.latestTimestamp(message)- Message.latestTimestamp(prevMessage)) < fiveMinutesInMilliseconds

  appendFollowOn: (message, followOn) ->
    if not message.followOns
      message.followOns = []
    message.followOns.push(followOn)

  latestTimestamp: (message) ->
    if message.followOns and message.followOns.length > 0
      _.last(message.followOns).timestamp
    else
      message.timestamp

  distillRawMessages: (rawMessages) ->
    # The distillation process sometimes needs to modify the objects it works
    # on.  Cloning them first makes sure that those modifications don't leak
    # out into the original raw messages.
    cloned = _.cloneDeep(rawMessages)

    _.reduce(cloned,
             (distilled, message) ->
              prevMessage = _.last(distilled)
              if prevMessage and Message.isFollowOn(message, prevMessage)
                Message.appendFollowOn(prevMessage, message)
              else
                distilled.push(message)
              distilled
             [])
}

Structural.Data.Message = Message
