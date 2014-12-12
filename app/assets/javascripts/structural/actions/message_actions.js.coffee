{buildMessage} = Structural.Data.Message
{nextId} = Structural.Data.TemporaryIdFactory

Structural.Actions.UpdateMessagesList = new Hippodrome.Action(
  'Update Messages List'
  (messages, conversation) ->
    messages: messages,
    conversation: conversation
)

Structural.Actions.SendMessage = new Hippodrome.Action(
  'Send Message'
  (user, text, conversation) ->
    message: buildMessage(user, {text: text})
    temporaryId: nextId()
    conversation: conversation
)

Structural.Actions.SendMessageSuccess = new Hippodrome.Action(
  'Send Message Success'
  (temporaryId, message, conversation) ->
    temporaryId: temporaryId,
    message: message
    conversation: conversation
)

Structural.Actions.SendMessageFailed = new Hippodrome.Action(
  'Send Messaged Failed'
  (temporaryId, conversation) ->
    temporaryId: temporaryId
    conversation: conversation
)

Structural.Actions.MarkRead = new Hippodrome.Action(
  'Mark Read'
  (message, conversation, folder) ->
    message: message
    conversation: conversation
    folder: folder
)
