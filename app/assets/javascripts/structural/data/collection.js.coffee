Collection = {
  arrayToIndexedHash: (arr, key) ->
    key = key or 'id'
    _.reduce(arr,
             (hash, obj) -> hash[obj[key]] = obj; hash,
             {})
}

Structural.Data.Collection = Collection
