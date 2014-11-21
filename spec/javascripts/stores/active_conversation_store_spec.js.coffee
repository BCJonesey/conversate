describe 'Stores.ActiveConversation', ->
  ActiveConvoStore = Structural.Stores.ActiveConversation._storeImpl

  conversations =
    10:
      id: 10
      most_recent_event: 100
    12:
      id: 12
      most_recent_event: 150
    14:
      id: 14
      most_recent_event: 200

  beforeEach ->
    ActiveConvoStore.activeConversationId = null

    spyOn(Structural.Stores.ActiveFolder, 'id').and.returnValue(5)
    spyOn(Structural.Stores.Folders, 'byId').and.returnValue({id: 5})
    spyOn(Structural.Stores.Conversations, 'chronologicalOrder')
      .and.returnValue([{id: 10}, {id: 12}, {id: 14}])

  it 'sets the active id directly', ->
    ActiveConvoStore.updateActiveConversationId({activeConversationId: 10})

    expect(ActiveConvoStore.activeConversationId).toBe(10)

  it 'sets the active id if it\'s a string', ->
    ActiveConvoStore.updateActiveConversationId({activeConversationId: '11'})

    expect(ActiveConvoStore.activeConversationId).toBe(11)

  it 'does nothing if it gets a list convos with the active id', ->
    ActiveConvoStore.activeConversationId = 12
    ActiveConvoStore.pickFirstIdIfNotInConversationList({conversations: conversations})

    expect(ActiveConvoStore.activeConversationId).toBe(12)

  it 'picks the chronologically first id if it gets a list of convos without the active id', ->
    ActiveConvoStore.activeConversationId = 15
    ActiveConvoStore.pickFirstIdIfNotInConversationList({conversations: conversations})

    expect(ActiveConvoStore.activeConversationId).toBe(10)

  it 'does nothing if gets a folder with the active id', ->
    spyOn(Structural.Stores.Conversations, 'byId').and.returnValue({id: 12})
    ActiveConvoStore.activeConversationId = 12
    ActiveConvoStore.pickFirstIdIfNotInFolder({activeFolderId: 5})

    expect(ActiveConvoStore.activeConversationId).toBe(12)

  it 'picks the chronologically first id if get a a folder without the active id', ->
    spyOn(Structural.Stores.Conversations, 'byId').and.returnValue(undefined)
    ActiveConvoStore.activeConversationId = 15
    ActiveConvoStore.pickFirstIdIfNotInFolder({activeFolderId: 6})

    expect(ActiveConvoStore.activeConversationId).toBe(10)
