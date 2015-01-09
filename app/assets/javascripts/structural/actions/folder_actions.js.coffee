Structural.Actions.UpdateFolderList = Hippodrome.createAction
  displayName: 'Update Folder List'
  build: (folders) -> {folders:folders}

Structural.Actions.UpdateActiveFolder = Hippodrome.createAction
  displayName: 'Update Active Folder'
  build: (activeFolderId) -> {activeFolderId: activeFolderId}
