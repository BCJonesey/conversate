{hashToSortedArray} = Structural.Data.Collection
{distillRawMessages} = Structural.Data.Message

Messages = new Structural.Flux.Store
  displayName: 'Messages Store'

  initialize: ->
    @rawMessages = {}

  dispatches: [{
    action: Structural.Actions.UpdateMessagesList
    callback: 'updateMessagesList'
  }]

  updateMessagesList: (payload) ->
    @rawMessages = payload.messages
    @trigger()

  chronologicalOrder: ->
    hashToSortedArray(@rawMessages, 'timestamp')

  distilled: ->
    distillRawMessages(@chronologicalOrder())

Structural.Stores.Messages = Messages
