SendMessage = new Hippodrome.DeferredTask
  action: Structural.Actions.SendMessage
  task: (payload) ->
    success = _.partial(Structural.Actions.SendMessageSuccess, payload.temporaryId)
    error = -> Structural.Actions.SendMessageFailed(payload.temporaryId)
    Structural.Api.Messages.newMessage(payload.message, payload.conversation, success, error)

    Structural.Actions.MarkRead(payload.message, payload.conversation)

Structural.Tasks.SendMessage = SendMessage
