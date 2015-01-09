{hashToSortedArray, Order} = Structural.Data.Collection

Conversations = Hippodrome.createStore
  displayName: 'Conversations Store'
  initialize: ->
    @conversationsByFolder = {}

    @dispatch(Structural.Actions.UpdateConversationList)
      .to(@updateConversationList)
    @dispatch(Structural.Actions.MarkRead).to(@updateMostRecentViewed)
    @dispatch(Structural.Actions.PinUnpinConversation).to(@pinUnpin)
    @dispatch(Structural.Actions.ArchiveUnarchiveConversation)
      .to(@archiveUnarchive)
    @dispatch(Structural.Actions.RetitleConversation).to(@retitle)
    @dispatch(Structural.Actions.UpdateFolders).to(@updateFolders)

  conversationsForFolder: (folder) ->
    if not folder
      return {}

    if not @conversationsByFolder[folder.id]
      @conversationsByFolder[folder.id] = {}

    @conversationsByFolder[folder.id]

  updateConversationList: (payload) ->
    # Assign instead of clobbering so that we can support temporary
    # (i.e., newly-created) conversations later.
    _.assign(@conversationsForFolder(payload.folder),
             payload.conversations)
    @trigger()

  updateMostRecentViewed: (payload) ->
    convo = @byId(payload.folder, payload.conversation.id)

    # In the case where this gets triggered because of an update folders message
    # that removes the conversation from the active folder, we don't have a
    # quick way to get to the conversation anymore, so screw it.
    if convo
      convo.most_recent_viewed = payload.message.timestamp
      @trigger()

  pinUnpin: (payload) ->
    convo = @byId(payload.folder, payload.conversation.id)
    convo.pinned = payload.pinned
    if payload.pinned
      convo.archived = false

    @trigger()

  archiveUnarchive: (payload) ->
    convo = @byId(payload.folder, payload.conversation.id)
    convo.archived = payload.archived
    if payload.archived
      convo.pinned = false

    @trigger()

  retitle: (payload) ->
    convo = @byId(payload.folder, payload.conversation.id)
    convo.title = payload.title
    @trigger()

  updateFolders: (payload) ->
    convo = payload.conversation
    for folder in payload.added
      @conversationsForFolder(folder)[convo.id] = convo
      convo.folder_ids.push(folder.id)

    for folder in payload.removed
      delete @conversationsForFolder(folder)[convo.id]
      convo.folder_ids = _.without(convo.folder_ids, folder.id)

    @trigger()

  public:
    byId: (folder, id) -> @conversationsForFolder(folder)[id]
    chronologicalOrder: (folder) ->
      hashToSortedArray(@conversationsForFolder(folder),
                        'most_recent_event',
                        Order.Descending)
    isEmpty: (folder) ->
      _.size(@conversationsForFolder(folder)) == 0

    # This is potentially real slow.  Don't call it unless you really really
    # have to.
    findFolderId: (id) ->
      id = '' + id
      for folderId in _.keys(@conversationsByFolder)
        for conversationId in _.keys(@conversationsByFolder[folderId])
          if conversationId == id
            return folderId

Structural.Stores.Conversations = Conversations
