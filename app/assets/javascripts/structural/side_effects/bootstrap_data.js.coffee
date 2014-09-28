BootstrapData = new Structural.Flux.SideEffect
  action: Structural.Actions.StartApp
  effect: (payload) ->
    # This is a much more convenient way to store conversations for components
    # to pull them out of the stores.  I think.
    conversations = _.reduce(bootstrap.conversations,
                             (obj, cnv) -> obj[cnv.id] = cnv; obj,
                             {})
    activeConversationId = if bootstrap.conversation then bootstrap.conversation.id else null

    _.defer ->
      Structural.Flux.Dispatcher.dispatch(
        Structural.Actions.UpdateConversationList(conversations))
      Structural.Flux.Dispatcher.dispatch(
        Structural.Actions.UpdateActiveConversation(activeConversationId))