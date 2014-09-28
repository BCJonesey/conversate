# For now I'm putting these all in one file.  They're so short that putting
# each action in its own file seems like more trouble than it's worth.  If this
# file gets too long, maybe break them up by category or something.

Structural.Actions = {}

Structural.Actions.StartApp = new Structural.Flux.Action -> {}

Structural.Actions.UpdateConversationList = new Structural.Flux.Action(
  (conversations) -> {conversations: conversations})

Structural.Actions.UpdateActiveConversation = new Structural.Flux.Action(
  (activeConversationId) -> {activeConversationId: activeConversationId})
