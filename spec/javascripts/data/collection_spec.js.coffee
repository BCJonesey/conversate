describe 'Data.Collection', ->
  describe 'hashToSortedArray', ->
    {hashToSortedArray, Order} = Structural.Data.Collection

    it 'converts an empty hash to an empty array', ->
      expect(hashToSortedArray({}, '')).toEqual([])

    it 'converts a hash into a sorted array', ->
      hash =
        10:
          timestamp: 5
          user: 'Alice'
        20:
          timestamp: 2
          user: 'Bob'
        30:
          timestamp: 8
          user: 'Charlie'
        40:
          timestamp: 1
          user: 'Deandra'

      sorted = [
        {
          timestamp: 1
          user: 'Deandra'
        }
        {
          timestamp: 2
          user: 'Bob'
        }
        {
          timestamp: 5
          user: 'Alice'
        }
        {
          timestamp: 8
          user: 'Charlie'
        }
      ]

      expect(hashToSortedArray(hash, 'timestamp')).toEqual(sorted)

    it 'sorts descending as well', ->
      hash =
        1: key: 4
        2: key: 8
        3: key: 2
        4: key: 6
      sorted = [{key: 8}, {key: 6}, {key: 4}, {key: 2}]

      expect(hashToSortedArray(hash, 'key', Order.Descending)).toEqual(sorted)

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
