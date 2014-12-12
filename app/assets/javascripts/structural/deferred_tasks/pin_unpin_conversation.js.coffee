{pinUnpin} = Structural.Api.Conversations

PinUnpinConversation = new Hippodrome.DeferredTask
  displayName: 'Pin Unpin Conversation'
  action: Structural.Actions.PinUnpinConversation
  task: (payload) ->
    convoProperties = _.assign(_.clone(payload.conversation), {pinned: payload.pinned})
    success = ->
    error = ->
    pinUnpin(convoProperties, payload.user, success, error)

Structural.Tasks.PinUnpinConversation = PinUnpinConversation
