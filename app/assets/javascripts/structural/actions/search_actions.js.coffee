Structural.Actions.ChangeSearchQuery = Hippodrome.createAction
  displayName: 'Change Search Query'
  build: (query) ->
    query: query

Structural.Actions.NewSearchResults = Hippodrome.createAction
  displayName: 'New Search Results'
  build: (results) ->
    results: results
