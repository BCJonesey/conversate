{hashToSortedArray} = Structural.Data.Collection

Messages = new Structural.Flux.Store
  displayName: 'Messages Store'

  initialize: ->
    @messages = {}

  dispatches: [{
    action: Structural.Actions.UpdateMessagesList
    callback: 'updateMessagesList'
  }]

  updateMessagesList: (payload) ->
    @messages = payload.messages
    @trigger()

  chronologicalOrder: ->
    hashToSortedArray(@messages, 'timestamp')

Structural.Stores.Messages = Messages
