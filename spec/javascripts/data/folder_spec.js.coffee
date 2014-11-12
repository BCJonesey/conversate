describe 'Data.Folder', ->
  describe 'isShared', ->
    {isShared} = Structural.Data.Folder

    it 'is shared when there are lots of users', ->
      folder =
        name: 'Shared'
        id: 10
        users: [
          {id: 1}
          {id: 2}
        ]

      expect(isShared(folder)).toBe(true)

    it 'is not shared when there is one user', ->
      folder =
        name: 'Not Shared'
        id: 11
        users: [{id: 3}]

      expect(isShared(folder)).toBe(false)
