{hashToSortedArray, Order} = Structural.Data.Collection

Conversations = new Hippodrome.Store
  displayName: 'Conversations Store'
  initialize: ->
    @conversationsByFolder = {}
  dispatches: [{
    action: Structural.Actions.UpdateConversationList
    callback: 'updateConversationList'
  },{
    action: Structural.Actions.MarkRead
    callback: 'updateMostRecentViewed'
  }, {
    action: Structural.Actions.PinUnpinConversation
    callback: 'pinUnpin'
  }, {
    action: Structural.Actions.ArchiveUnarchiveConversation
    callback: 'archiveUnarchive'
  }, {
    action: Structural.Actions.RetitleConversation
    callback: 'retitle'
  }, {
    action: Structural.Actions.UpdateFolders
    callback: 'updateFolders'
  }]

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

    for folder in payload.removed
      delete @conversationsForFolder(folder)[convo.id]

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
