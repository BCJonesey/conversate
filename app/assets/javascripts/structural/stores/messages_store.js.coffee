{hashToSortedArray} = Structural.Data.Collection

MessagesStore = new Structural.Flux.Store
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

  sortedMessages: ->
    hashToSortedArray(@messages)

Structural.Stores.MessagesStore = MessagesStore
