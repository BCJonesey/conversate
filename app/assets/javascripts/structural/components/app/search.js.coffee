{div, input, a} = React.DOM

Search = React.createClass
  displayName: 'Search'

  mixins: [Structural.Stores.Search.listenWith('updateSearch')]

  updateSearch: ->
    query = Structural.Stores.Search.getQuery()
    query: query
    results: Structural.Stores.Search.getResults(query)

  render: ->
    {Icon} = Structural.Components

    if @state.results is null
      results = Icon({name: 'gear', spin: true})

    else if _.isEmpty(@state.results)
      results = Icon({name: 'gear', spin: true})

    else
      results = _.map @state.results, (result) ->
        div className: 'search-result', result

    div className: 'search',
      input
        type: 'text',
        placeholder: 'Search',
        value: @state.value
        onChange: (event) ->
          Structural.Actions.ChangeSearchQuery(event.target.value)
      div className:'search-results',

Structural.Components.News = React.createFactory(Search)
