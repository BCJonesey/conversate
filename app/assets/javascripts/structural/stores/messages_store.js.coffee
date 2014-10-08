{hashToSortedArray} = Structural.Data.Collection
{distillRawMessages, buildMessage} = Structural.Data.Message

Messages = new Structural.Flux.Store
  displayName: 'Messages Store'

  initialize: ->
    @rawMessages = {}

  dispatches: [
    {
      action: Structural.Actions.UpdateMessagesList
      callback: 'updateMessagesList'
    }
    {
      action: Structural.Actions.SendMessage
      callback: 'appendTemporaryMessage'
    }
    {
      action: Structural.Actions.SendMessageSuccess
      callback: 'replaceTemporaryMessage'
    }
  ]

  updateMessagesList: (payload) ->
    @rawMessages = payload.messages
    @trigger()

  appendTemporaryMessage: (payload) ->
    @rawMessages[payload.temporaryId] = payload.message
    @trigger()

  replaceTemporaryMessage: (payload) ->
    @rawMessages[payload.message.id] = payload.message
    delete @rawMessages[payload.temporaryId]
    @trigger()

  chronologicalOrder: ->
    hashToSortedArray(@rawMessages, 'timestamp')

  distilled: ->
    distillRawMessages(@chronologicalOrder())

Structural.Stores.Messages = Messages
