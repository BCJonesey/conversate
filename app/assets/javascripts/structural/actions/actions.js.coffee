# For now I'm putting these all in one file.  They're so short that putting
# each action in its own file seems like more trouble than it's worth.  If this
# file gets too long, maybe break them up by category or something.

Structural.Actions = {}

{buildMessage} = Structural.Data.Message

Structural.Actions.StartApp = new Structural.Flux.Action(
  'Start App',
   -> {})

Structural.Actions.UpdateConversationList = new Structural.Flux.Action(
  'Update Conversation List'
  (conversations) -> {conversations: conversations})

Structural.Actions.UpdateActiveConversation = new Structural.Flux.Action(
  'Update Active Conversation'
  (activeConversationId) -> {activeConversationId: activeConversationId})

Structural.Actions.UpdateMessagesList = new Structural.Flux.Action(
  'Update Messages List'
  (messages) -> {messages: messages}
)

Structural.Actions.UpdateCurrentUser = new Structural.Flux.Action(
  'Update Current User'
  (user) -> {user: user}
)

lastMsgTempId = 1
nextMsgTempId = -> "Temporary_Message_ID_#{lastMsgTempId++}"
Structural.Actions.SendMessage = new Structural.Flux.Action(
  'Send Message'
  (user, text, conversation) ->
    message: buildMessage(user, text)
    temporaryId: nextMsgTempId()
    conversation: conversation
)

Structural.Actions.SendMessageSuccess = new Structural.Flux.Action(
  'Send Message Success'
  (temporaryId, message) ->
    temporaryId: temporaryId,
    message: message
)

Structural.Actions.SendMessageFailed = new Structural.Flux.Action(
  'Send Messaged Failed'
  (temporaryId) ->
    temporaryId: temporaryId
)
