{updateMostRecentViewed} = Structural.Api.Conversations
{Conversations, CurrentUser} = Structural.Stores

MarkRead = new Hippodrome.DeferredTask
  action: Structural.Actions.MarkRead
  task: (payload) ->
    convo = Conversations.byId(payload.folder, payload.conversation.id)
    user = CurrentUser.getUser()

    # This api endpoint returns the user, which we don't really want to do
    # anything with.
    success = ->
    error = ->
    updateMostRecentViewed(convo, user, success, error)

Structural.Tasks.MarkRead = MarkRead
