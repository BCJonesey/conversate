{hashToSortedArray, Order} = Structural.Data.Collection

Conversations = new Hippodrome.Store
  displayName: 'Conversations Store'
  initialize: ->
    @conversationsByFolder = {}
  dispatches: [
    {
      action: Structural.Actions.UpdateConversationList
      callback: 'updateConversationList'
    }
    {
      action: Structural.Actions.MarkRead
      callback: 'updateMostRecentViewed'
    }
  ]

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
    convo.most_recent_viewed = payload.message.timestamp
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
