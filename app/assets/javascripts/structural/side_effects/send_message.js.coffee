SendMessage = new Structural.Flux.SideEffect
  action: Structural.Actions.SendMessage
  effect: (payload) ->
    success = _.partial(Structural.Actions.SendMessageSuccess, payload.temporaryId)
    error = -> Structural.Actions.SendMessageFailed(payload.temporaryId)
    Structural.Api.Messages.newMessage(payload.message, payload.conversation, success, error)

Structural.SideEffects.SendMessage = SendMessage
