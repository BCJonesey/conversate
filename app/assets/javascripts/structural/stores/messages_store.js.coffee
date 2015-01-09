{hashToSortedArray} = Structural.Data.Collection
{distillRawMessages, buildMessage} = Structural.Data.Message

Messages = Hippodrome.createStore
  displayName: 'Messages Store'

  initialize: ->
    @rawMessagesByConversation = {}

    @dispatch(Structural.Actions.UpdateMessagesList).to(@updateMessagesList)
    @dispatch(Structural.Actions.SendMessage).to(@appendTemporaryMessage)
    @dispatch(Structrual.Actions.SendMessageSuccess)
      .to(@replaceTemporaryMessage)
    @dispatch(Structural.Actions.RetitleConversation)
      .to(@appendTemporaryMessage)
    @dispatch(Structural.Actions.UpdateFolders).to(@appendTemporaryMessage)

  messagesForConversation: (conversation) ->
    if not conversation
      return {}

    if not @rawMessagesByConversation[conversation.id]
      @rawMessagesByConversation[conversation.id] = {}

    @rawMessagesByConversation[conversation.id]

  updateMessagesList: (payload) ->
    # Assign here instead of clobbering so that we don't lose track of
    # temporary messages.
    _.assign(@messagesForConversation(payload.conversation),
             payload.messages)
    @trigger()

  appendTemporaryMessage: (payload) ->
    messages = @messagesForConversation(payload.conversation)
    messages[payload.temporaryId] = payload.message
    @trigger()

  replaceTemporaryMessage: (payload) ->
    messages = @messagesForConversation(payload.conversation)
    messages[payload.message.id] = payload.message
    delete messages[payload.temporaryId]
    @trigger()

  public:
    chronologicalOrder: (conversation) ->
      if not conversation
        []
      else
        hashToSortedArray(@messagesForConversation(conversation), 'timestamp')

    distilled: (conversation) ->
      distillRawMessages(@chronologicalOrder(conversation))

    isEmpty: (conversation) ->
      _.size(@messagesForConversation(conversation)) == 0

Structural.Stores.Messages = Messages
