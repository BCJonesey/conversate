{UrlFactory, UrlReader} = Structural.Urls
{Conversations, Folders, ActiveFolder} = Structural.Stores

ChangeUrl = Hippodrome.createDeferredTask
  displayName: 'Change Url'
  initialize: (options) ->
    @dispatch(Structural.Actions.UpdateActiveFolder).to(@setFolderUrl)
    @dispatch(Structural.Actions.UpdateActiveConversation)
      .to(@setConversationUrl)

    @setupPopstateEvent(options)

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
    else if url.type == 'people'
      Structural.Actions.UpdateActiveContactList(url.contactListId)

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
