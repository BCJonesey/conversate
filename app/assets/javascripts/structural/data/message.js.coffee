# Operations used later in distillRawMessages
appendFollowOnOperation = {
  condition: (distilled, message) ->
    prevMessage = _.last(distilled)
    prevMessage and Message.isFollowOn(message, prevMessage)
  operation: (distilled, message) ->
    prevMessage = _.last(distilled)
    Message.appendFollowOn(prevMessage, message)
}
appendMessageOperation = {
  condition: (distilled, message) -> true
  operation: (distilled, message) -> distilled.push(message)
}

Message = {
  isMessageType: (message) ->
    message.type in ['message', 'email_message', 'upload_message']

  isFollowOn: (message, prevMessage) ->
    Message.isMessageType(message) and
    Message.isMessageType(prevMessage) and
    message.user.id == prevMessage.user.id and
    (Message.latestTimestamp(message)- Message.latestTimestamp(prevMessage)) < Structural.Data.Time.fiveMinutesInMilliseconds

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

    operations = [
      appendFollowOnOperation
      appendMessageOperation
    ]

    _.reduce(cloned,
             (distilled, message) ->
              for operation in operations
                if operation.condition(distilled, message)
                  operation.operation(distilled, message)
                  return distilled;
             [])

  isUsersMessage: (message, user) ->
    # Coercing to boolean here so that we don't return whatever user is when
    # the and short-circuits.
    !!(user and (message.user.id == user.id))
}

Structural.Data.Message = Message
