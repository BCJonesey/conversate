# For now I'm putting these all in one file.  They're so short that putting
# each action in its own file seems like more trouble than it's worth.  If this
# file gets too long, maybe break them up by category or something.

Structural.Actions = {}

{buildMessage} = Structural.Data.Message

Structural.Actions.StartApp = new Hippodrome.Action(
  'Start App',
   -> {})

Structural.Actions.UpdateFolderList = new Hippodrome.Action(
  'Update Folder List'
  (folders) -> {folders:folders}
)

Structural.Actions.UpdateActiveFolder = new Hippodrome.Action(
  'Update Active Folder'
  (activeFolderId) -> {activeFolderId: activeFolderId}
)

Structural.Actions.UpdateConversationList = new Hippodrome.Action(
  'Update Conversation List'
  (conversations) -> {conversations: conversations})

Structural.Actions.UpdateActiveConversation = new Hippodrome.Action(
  'Update Active Conversation'
  (activeConversationId) -> {activeConversationId: activeConversationId})

Structural.Actions.UpdateMessagesList = new Hippodrome.Action(
  'Update Messages List'
  (messages, conversation) ->
    messages: messages,
    conversation: conversation
)

Structural.Actions.UpdateCurrentUser = new Hippodrome.Action(
  'Update Current User'
  (user) -> {user: user}
)

lastMsgTempId = 1
nextMsgTempId = -> "Temporary_Message_ID_#{lastMsgTempId++}"
Structural.Actions.SendMessage = new Hippodrome.Action(
  'Send Message'
  (user, text, conversation) ->
    message: buildMessage(user, text)
    temporaryId: nextMsgTempId()
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
  (message, conversation) ->
    message: message
    conversation: conversation
)
