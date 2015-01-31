Search = Hippodrome.createStore
  displayName: 'Search Store'
  initialize: ->
    @_query = ''
    @_results = {}

    @dispatch(Structural.Actions.ChangeSearchQuery).to(@changeQuery)
    @dispatch(Structural.Actions.NewSearchResults).to(@newSearchResults)

  changeQuery: (payload) ->
    @_query = payload.query
    @trigger()

  newSearchResults: (payload) ->
    @_results[payload.query] = payload.results

  public:
    getQuery: (contactList) ->
      @_query

    getResults: (query) ->
      @_results[query]

Structural.Stores.Search = Search
