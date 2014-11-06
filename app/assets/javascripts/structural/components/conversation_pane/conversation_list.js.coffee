{div} = React.DOM
{isPinned, isArchived, isParticipatingIn} = Structural.Data.Conversation

ConversationList = React.createClass
  displayName: 'Conversation List'
  render: ->
    Section = Structural.Components.ConversationListSection

    inPinnedSection = (c) -> isPinned(c)
    inArchivedSection = (c) -> isArchived(c) and not isPinned(c)
    inSharedSection = (c) => not isParticipatingIn(c, @props.user) and
                             not isPinned(c) and
                             not isArchived(c)
    inMySection = (c) => not isPinned(c) and
                         not isArchived(c) and
                         isParticipatingIn(c, @props.user)

    pinnedConvos = _.filter(@props.conversations, inPinnedSection)
    archivedConvos = _.filter(@props.conversations, inArchivedSection)
    myConvos = _.filter(@props.conversations, inMySection)
    sharedConvos = _.filter(@props.conversations, inSharedSection)

    div {className: 'conversation-list'},
      Section({
        title: 'Pinned Conversations'
        conversations: pinnedConvos
        activeConversation: @props.activeConversation})
      Section({
        title: 'My Conversations'
        conversations: myConvos
        activeConversation: @props.activeConversation})
      Section({
        title: 'Shared Conversations'
        conversations: sharedConvos
        activeConversation: @props.activeConversation})
      Section({
        title: 'Archive'
        conversations: archivedConvos
        activeConversation: @props.activeConversation})

Structural.Components.ConversationList = ConversationList
