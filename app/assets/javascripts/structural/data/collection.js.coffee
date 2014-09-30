Collection = {
  arrayToIndexedHash: (arr, key) ->
    key = key or 'id'
    _.reduce(arr,
             (hash, obj) -> hash[obj[key]] = obj; hash,
             {})

  hashToSortedArray: (hash, key) ->
    _.sortBy(_.values(hash), key)
}

Structural.Data.Collection = Collection
