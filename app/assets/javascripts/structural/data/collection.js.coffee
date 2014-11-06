Collection = {
  Order: {
    Ascending: 'ascending'
    Descending: 'descending'
  }

  arrayToIndexedHash: (arr, key) ->
    key = key or 'id'
    _.reduce(arr,
             (hash, obj) -> hash[obj[key]] = obj; hash,
             {})

  # Assume that if you want to reverse-sort a collection your key is a number.
  # I'm not sure how to invert the sort order of a string, and I'd rather not
  # do full array reverse (which I think is O(n)) if I can avoid it.
  hashToSortedArray: (hash, key, order) ->
    order ||= Collection.Order.Ascending
    keyFn = (o) ->
      if order == Collection.Order.Descending
        -o[key]
      else
        o[key]

    _.sortBy(_.values(hash), keyFn)
}

Structural.Data.Collection = Collection
