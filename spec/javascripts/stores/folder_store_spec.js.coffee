describe 'Stores.Folders', ->
  FoldersStore = Structural.Stores.Folders._storeImpl

  folders =
    1:
      id: 1
      name: 'Aardvark'
    4:
      id: 4
      name: 'Dentist'
    2:
      id: 2
      name: 'Banana'
    3:
      id: 3
      name: 'Calculator'

  beforeEach ->
    FoldersStore.updateFolderList({folders: {}})

  it 'is empty by default', ->
    expect(FoldersStore.byId(2)).toBe(undefined)

  it 'changes the list of folders on update', ->
    FoldersStore.updateFolderList({folders: folders})

    expect(FoldersStore.byId(3).name).toBe('Calculator')

  it 'turns into a list', ->
    FoldersStore.updateFolderList({folders: folders})

    list = [
      {id: 1, name: 'Aardvark'},
      {id: 2, name: 'Banana'},
      {id: 3, name: 'Calculator'},
      {id: 4, name: 'Dentist'}
    ]

    expect(FoldersStore.asList()).toEqual(list)
