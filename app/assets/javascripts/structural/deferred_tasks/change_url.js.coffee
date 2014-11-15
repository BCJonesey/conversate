{UrlFactory, UrlReader} = Structural.Urls
{Conversations, Folders, ActiveFolder} = Structural.Stores

ChangeUrl = new Hippodrome.DeferredTask
  displayName: 'Change Url'
  dispatches: [{
    action: Structural.Actions.StartApp
    callback: 'setupPopstateEvent'
  }, {
    action: Structural.Actions.UpdateActiveFolder
    callback: 'setFolderUrl'
  }, {
    action: Structural.Actions.UpdateActiveConversation
    callback: 'setConversationUrl'
  }]

  push: (url) ->
    window.history.pushState(null, '', url)
  updateActiveByUrl: ->
    url = UrlReader.read(window.location.pathname)
    if url.type == 'folder'
      Structural.Actions.UpdateActiveFolder(url.id)
    else if url.type == 'conversation'
      activeFolder = Folders.byId(ActiveFolder.id())
      if not Conversations.byId(activeFolder, url.id)
        folderId = Conversations.findFolderId(url.id)
        Structural.Actions.UpdateActiveFolder(folderId)

      Structural.Actions.UpdateActiveConversation(url.id)

    # TODO: 404 stuff

  setupPopstateEvent: (payload) ->
    window.onpopstate = @updateActiveByUrl
    @updateActiveByUrl()

  setFolderUrl: (payload) ->
    folder = Folders.byId(payload.activeFolderId)
    @push(UrlFactory.folder(folder))
  setConversationUrl: (payload) ->
    folder = Folders.byId(ActiveFolder.id())
    conversation = Conversations.byId(folder, payload.activeConversationId)
    @push(UrlFactory.conversation(conversation))

Structural.Tasks.ChangeUrl = ChangeUrl
