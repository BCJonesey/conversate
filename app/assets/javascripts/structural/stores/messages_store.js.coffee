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
  ]

  updateMessagesList: (payload) ->
    @rawMessages = payload.messages
    @trigger()

  appendTemporaryMessage: (payload) ->
    @rawMessages[payload.temporaryId] = payload.message
    @trigger()

  chronologicalOrder: ->
    hashToSortedArray(@rawMessages, 'timestamp')

  distilled: ->
    distillRawMessages(@chronologicalOrder())

Structural.Stores.Messages = Messages
