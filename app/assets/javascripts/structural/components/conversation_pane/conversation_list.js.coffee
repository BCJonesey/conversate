{div} = React.DOM
{isPinned, isArchived, isParticipatingIn} = Structural.Data.Conversation

ConversationList = React.createClass
  displayName: 'Conversation List'

  componentDidUpdate: ->
    dom = @getDOMNode()
    # There should only ever be one active conversation.  If there's more than
    # one, something's gone very wrong.
    active = _.first(dom.getElementsByClassName('active-conversation'))

    if not active
      return

    activeTop = active.offsetTop
    activeBottom = activeTop + active.clientHeight
    scrollTop = dom.scrollTop
    scrollBottom = scrollTop + dom.clientHeight

    if activeBottom >= scrollTop and activeTop <= scrollBottom
      return

    dom.scrollTop = Math.max(0, activeTop - (dom.clientHeight / 2))

  render: ->
    {ConversationListSection, LoadingConversations} = Structural.Components

    if @props.loading
      return LoadingConversations()

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
      ConversationListSection({
        title: 'Pinned Conversations'
        adjective: 'pinned'
        conversations: pinnedConvos
        activeConversation: @props.activeConversation})
      ConversationListSection({
        title: 'My Conversations'
        adjective: ''
        conversations: myConvos
        activeConversation: @props.activeConversation})
      ConversationListSection({
        title: 'Shared Conversations'
        adjective: 'shared'
        conversations: sharedConvos
        activeConversation: @props.activeConversation})
      ConversationListSection({
        title: 'Archive'
        adjective: 'archived'
        conversations: archivedConvos
        activeConversation: @props.activeConversation
        startCollapsed: true})

Structural.Components.ConversationList = ConversationList
