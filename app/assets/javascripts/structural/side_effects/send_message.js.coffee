SendMessage = new Hippodrome.SideEffect
  action: Structural.Actions.SendMessage
  effect: (payload) ->
    success = _.partial(Structural.Actions.SendMessageSuccess, payload.temporaryId)
    error = -> Structural.Actions.SendMessageFailed(payload.temporaryId)
    Structural.Api.Messages.newMessage(payload.message, payload.conversation, success, error)

    Structural.Actions.MarkRead(payload.message, payload.conversation)

Structural.SideEffects.SendMessage = SendMessage
