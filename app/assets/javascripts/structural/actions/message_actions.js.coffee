{buildMessage} = Structural.Data.Message
{nextId} = Structural.Data.TemporaryIdFactory

Structural.Actions.UpdateMessagesList = Hippodrome.createAction
  displayName: 'Update Messages List'
  build: (messages, conversation) ->
    messages: messages,
    conversation: conversation

Structural.Actions.SendMessage = Hippodrome.createAction
  displayName: 'Send Message'
  build: (user, text, conversation) ->
    message: buildMessage(user, {text: text})
    temporaryId: nextId()
    conversation: conversation

Structural.Actions.SendMessageSuccess = Hippodrome.createAction
  displayName: 'Send Message Success'
  build: (temporaryId, message, conversation) ->
    temporaryId: temporaryId,
    message: message
    conversation: conversation

Structural.Actions.SendMessageFailed = Hippodrome.createAction
  displayName: 'Send Messaged Failed'
  build: (temporaryId, conversation) ->
    temporaryId: temporaryId
    conversation: conversation

Structural.Actions.MarkRead = Hippodrome.createAction
  displayName: 'Mark Read'
  build: (message, conversation, folder) ->
    message: message
    conversation: conversation
    folder: folder
