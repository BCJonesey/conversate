{div} = React.DOM
{isPinned, isArchived, isParticipatingIn} = Structural.Data.Conversation

ConversationList = React.createClass
  displayName: 'Conversation List'

  componentWillUpdate: ->
    dom = @getDOMNode()
    # There should only ever be one active conversation.  If there's more than
    # one, something's gone very wrong.
    @active = _.first(dom.getElementsByClassName('active-conversation'))

    if not @active
      @activeWasVisible = false
      return

    activeTop = @active.offsetTop
    activeBottom = activeTop + @active.clientHeight
    scrollTop = dom.scrollTop
    scrollBottom = scrollTop + dom.clientHeight

    @activeWasVisible = not (activeBottom >= scrollTop and activeTop <= scrollBottom)

  componentDidUpdate: ->
    if @activeWasVisible
      dom = @getDOMNode()
      activeTop = @active.offsetTop
      activeBottom = activeTop + @active.clientHeight
      scrollTop = dom.scrollTop
      scrollBottom = scrollTop + dom.clientHeight

      if not activeBottom >= scrollTop and activeTop <= scrollBottom
        dom.scrollTop = activeTop - (dom.clientHeight / 2)

  render: ->
    {ConversationListSection, LoadingConversations,
     NoConversations} = Structural.Components

    if @props.loading
      return LoadingConversations()

    if @props.conversations.length == 0
      return NoConversations()

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
        description: "Pinned conversations stay in this top section so you can
                      find them easily.  They're for things you're actively
                      working on or conversation you need to follow up on.  Pin
                      or un-pin a conversation using the conversation menu near
                      the top left."
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
        description: "Shared conversations are any conversations that are in
                      this folder but you aren't participating in.  Use them to
                      keep track of what your teammates are working on without
                      having to get bombarded with notifications.  You can join
                      or leave a conversation at any time."
        conversations: sharedConvos
        activeConversation: @props.activeConversation})
      ConversationListSection({
        title: 'Archive'
        adjective: 'archived'
        description: "Archived conversations are any that you don't need to pay
                      attention to anymore.  The archived conversations section
                      is collapsed by default so you can ignore it, but they'll
                      still show up in searches.  If someone starts talking in a
                      conversation you've archived, it'll get un-archived
                      automatically, so don't worry about missing important
                      messages."
        conversations: archivedConvos
        activeConversation: @props.activeConversation
        startCollapsed: true})

Structural.Components.ConversationList = React.createFactory(ConversationList)
