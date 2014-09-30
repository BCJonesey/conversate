describe 'Data.Collection', ->
  describe 'arrayToIndexedHash', ->
    {arrayToIndexedHash} = Structural.Data.Collection
    arr = [
      {
        name: 'Alice'
        email: 'alice@example.com'
        id: 10
      }
      {
        name: 'Bob'
        email: 'bob@example.com'
        id: 20
      }
      {
        name: 'Charlie'
        email: 'charlie@example.com'
        id: 30
      }
    ]

    it 'converts an empty array to an empty object', ->
      expect(arrayToIndexedHash([], 'name')).toEqual({})

    it 'converts an array to a properly indexed object', ->
      byName =
        Alice:
          name: 'Alice'
          email: 'alice@example.com'
          id: 10
        Bob:
          name: 'Bob'
          email: 'bob@example.com'
          id: 20
        Charlie:
          name: 'Charlie'
          email: 'charlie@example.com'
          id: 30

      expect(arrayToIndexedHash(arr, 'name')).toEqual(byName)

    it 'uses `id` as the key if none is given', ->
      byId =
        10:
          name: 'Alice'
          email: 'alice@example.com'
          id: 10
        20:
          name: 'Bob'
          email: 'bob@example.com'
          id: 20
        30:
          name: 'Charlie'
          email: 'charlie@example.com'
          id: 30

      expect(arrayToIndexedHash(arr)).toEqual(byId)
