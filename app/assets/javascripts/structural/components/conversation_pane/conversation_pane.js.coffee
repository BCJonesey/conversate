{Conversations, CurrentUser} = Structural.Stores
{isPinned, isArchived, isParticipatingIn} = Structural.Data.Conversation
{div} = React.DOM

ConversationPane = React.createClass
  displayName: 'Conversation Pane'
  mixins: [
    Conversations.listen('updateConversations')
    CurrentUser.listen('updateUser')
  ]

  getInitialState: ->
    conversations: Conversations.chronologicalOrder()
    user: CurrentUser.getUser()

  updateConversations: ->
    @setState(conversations: Conversations.chronologicalOrder())
  updateUser: ->
    @setState(user: CurrentUser.getUser())

  render: ->
    Section = Structural.Components.ConversationListSection


    inPinnedSection = (c) -> isPinned(c)
    inArchivedSection = (c) -> isArchived(c) and not isPinned(c)
    inSharedSection = (c) => not isParticipatingIn(c, @state.user) and not isPinned(c) and not isArchived(c)
    inMySection = (c) => not isPinned(c) and not isArchived(c) and isParticipatingIn(c, @state.user)

    pinnedConvos = _.filter(@state.conversations, inPinnedSection)
    archivedConvos = _.filter(@state.conversations, inArchivedSection)
    usersConvos = _.filter(@state.conversations, inMySection)
    sharedConvos = _.filter(@state.conversations, inSharedSection)

    div {className: 'conversation-pane'},
      Structural.Components.ConversationActions(),
      div {className: 'conversation-list'},
        Section({title: 'Pinned Conversations', conversations: pinnedConvos}),
        Section({title: 'My Conversations', conversations: usersConvos}),
        Section({title: 'Shared Conversations', conversations: sharedConvos}),
        Section({title: 'Archive', conversations: archivedConvos})

Structural.Components.ConversationPane = ConversationPane
