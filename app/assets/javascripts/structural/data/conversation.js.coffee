Conversation = {
  isPinned: (conversation) -> conversation.pinned
  isArchived: (conversation) -> conversation.archived
  isParticipatingIn: (conversation, user) ->
    if not user
      return false

    ids = _.pluck(conversation.participants, 'id')
    _.contains(ids, user.id)
}

Structural.Data.Conversation = Conversation
