{hashToSortedArray} = Structural.Data.Collection
{distillRawMessages, buildMessage} = Structural.Data.Message

Messages = new Hippodrome.Store
  displayName: 'Messages Store'

  initialize: ->
    @rawMessagesByConversation = {}

  dispatches: [{
    action: Structural.Actions.UpdateMessagesList
    callback: 'updateMessagesList'
  }, {
    action: Structural.Actions.SendMessage
    callback: 'appendTemporaryMessage'
  }, {
    action: Structural.Actions.SendMessageSuccess
    callback: 'replaceTemporaryMessage'
  }, {
    action: Structural.Actions.RetitleConversation
    callback: 'appendTemporaryMessage'
  }]

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
